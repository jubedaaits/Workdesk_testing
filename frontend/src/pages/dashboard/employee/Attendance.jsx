import React, { useState, useEffect, useRef } from 'react';
import './Attendance.css';
import { attendanceAPI } from '../../../services/attendanceAPI';

const AttendanceTable = () => {
  const [attendance, setAttendance] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [filterStatus, setFilterStatus] = useState('All');
  const [formData, setFormData] = useState({
    date: new Date().toISOString().split('T')[0],
    checkIn: '',
    checkOut: '',
  });

  // Face recognition states
  const [isCameraOpen, setIsCameraOpen] = useState(false);
  const [cameraStream, setCameraStream] = useState(null);
  const [faceRecognitionLoading, setFaceRecognitionLoading] = useState(false);
  const [faceVerificationStep, setFaceVerificationStep] = useState('ready');
  const [pin, setPin] = useState('');
  const [verificationResult, setVerificationResult] = useState(null);
  
  const videoRef = useRef(null);
  const canvasRef = useRef(null);

  // Fetch attendance history from backend - FIXED
  const fetchAttendanceHistory = async () => {
    try {
      setLoading(true);
      
      const response = await attendanceAPI.getMyHistory();
      // console.log('📊 Attendance history response:', response.data);
      
      if (response.data.success) {
        // FIXED: Check if history exists and map correctly
        const historyData = response.data.history || [];
        
        const transformedData = historyData.map(record => ({
          id: record.history_id || record.id || Math.random(),
          date: record.date,
          checkIn: record.check_in_time || '--',
          checkOut: record.check_out_time || '--',
          status: record.status || 'Pending',
          employee: record.employee_name || 'Current User',
          remarks: record.remarks || '',
          isHalfDay: record.is_half_day || false,
          workedHours: record.worked_hours || 0
        }));
        
        setAttendance(transformedData);
      } else {
        setError(response.data.message || 'Failed to fetch attendance data');
      }
    } catch (err) {
      console.error('❌ Error fetching attendance:', err);
      setError(err.response?.data?.message || 'Error loading attendance data');
    } finally {
      setLoading(false);
    }
  };

  // Fetch today's attendance status - FIXED
  const fetchTodayAttendance = async () => {
    try {
      const response = await attendanceAPI.getMyTodayAttendance();
      // console.log('Today\'s attendance:', response.data);
      // Don't try to access properties that might not exist
      if (response.data && response.data.attendance) {
        // You can use this data to show current status if needed
        return response.data.attendance;
      }
    } catch (err) {
      console.error('Error fetching today attendance:', err);
    }
    return null;
  };

  useEffect(() => {
    fetchAttendanceHistory();
    fetchTodayAttendance();
  }, []);

  // Camera functions
  const startCamera = async () => {
    try {
      setIsCameraOpen(true);
      setFaceVerificationStep('camera');
      const stream = await navigator.mediaDevices.getUserMedia({ 
        video: { 
          width: 640, 
          height: 480,
          facingMode: 'user' 
        } 
      });
      
      setCameraStream(stream);
      if (videoRef.current) {
        videoRef.current.srcObject = stream;
      }
    } catch (error) {
      console.error('Error accessing camera:', error);
      alert('Unable to access camera. Please check permissions.');
      setIsCameraOpen(false);
      setFaceVerificationStep('ready');
    }
  };

  const stopCamera = () => {
    if (cameraStream) {
      cameraStream.getTracks().forEach(track => track.stop());
      setCameraStream(null);
    }
    setIsCameraOpen(false);
    setFaceVerificationStep('ready');
    setPin('');
    setVerificationResult(null);
  };

  const captureAndVerify = async () => {
    if (!videoRef.current) return;

    setFaceRecognitionLoading(true);

    try {
      const video = videoRef.current;
      const canvas = canvasRef.current;
      const context = canvas.getContext('2d');
      
      canvas.width = video.videoWidth;
      canvas.height = video.videoHeight;
      context.drawImage(video, 0, 0, canvas.width, canvas.height);
      
      const blob = await new Promise((resolve) => {
        canvas.toBlob(resolve, 'image/jpeg', 0.8);
      });

      if (!blob) {
        throw new Error('Failed to capture image');
      }

      const formData = new FormData();
      formData.append('faceImage', blob, 'face-capture.jpg');

      const response = await attendanceAPI.verifyMyFaceAndMarkAttendance(formData);
      
      if (response.data.success) {
        setVerificationResult({
          success: true,
          message: `✅ Attendance marked successfully!`,
          details: {
            status: response.data.attendance?.status || 'Present',
            checkIn: response.data.attendance?.check_in_time || new Date().toLocaleTimeString(),
            shift: response.data.attendance?.shift_name || response.data.attendance?.shift || 'Default',
            confidence: response.data.confidence || 'High'
          }
        });
        
        await fetchAttendanceHistory();
        
        setTimeout(() => {
          stopCamera();
          alert('Attendance marked successfully!');
        }, 3000);
        
      } else if (response.data.requiresPIN) {
        setFaceVerificationStep('pin-required');
        setVerificationResult({
          success: false,
          message: '🔒 Additional verification required',
          confidence: response.data.confidence
        });
      } else {
        setVerificationResult({
          success: false,
          message: response.data.message || 'Face verification failed'
        });
        
        setTimeout(() => {
          setVerificationResult(null);
        }, 3000);
      }
    } catch (err) {
      console.error('❌ Face verification error:', err);
      setVerificationResult({
        success: false,
        message: err.response?.data?.message || 'Error during face verification'
      });
    } finally {
      setFaceRecognitionLoading(false);
    }
  };

  const handlePINVerification = async () => {
    if (!pin) {
      alert('Please enter your PIN');
      return;
    }

    try {
      setFaceRecognitionLoading(true);
      
      const attendanceData = {
        type: 'check_in',
        date: new Date().toISOString().split('T')[0],
        pin: pin
      };
      
      const response = await attendanceAPI.markMyAttendance(attendanceData);
      
      if (response.data.success) {
        setVerificationResult({
          success: true,
          message: `✅ Attendance marked with PIN verification!`,
          details: {
            status: response.data.attendance?.status || 'Present',
            checkIn: new Date().toLocaleTimeString()
          }
        });
        
        await fetchAttendanceHistory();
        
        setTimeout(() => {
          stopCamera();
          alert('Attendance marked successfully with PIN verification!');
        }, 3000);
      } else {
        alert(response.data.message || 'PIN verification failed');
        setPin('');
      }
      
    } catch (err) {
      console.error('PIN verification error:', err);
      alert(err.response?.data?.message || 'Error during PIN verification');
    } finally {
      setFaceRecognitionLoading(false);
    }
  };

  const handleFaceRecognitionAttendance = async () => {
    startCamera();
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!formData.date) {
      alert('Please select a date');
      return;
    }

    try {
      let type = 'check_in';
      if (formData.checkOut) {
        type = 'check_out';
      }

      const attendanceData = {
        type: type,
        date: formData.date,
        check_in_time: formData.checkIn,
        check_out_time: formData.checkOut
      };

      const response = await attendanceAPI.markMyAttendance(attendanceData);
      
      setIsModalOpen(false);
      
      setFormData({
        date: new Date().toISOString().split('T')[0],
        checkIn: '',
        checkOut: '',
      });
      
      if (response.data && response.data.success) {
        await fetchAttendanceHistory();
        alert(`${type === 'check_in' ? 'Check-in' : 'Check-out'} successful!`);
      } else {
        alert(response.data?.message || 'Failed to mark attendance');
      }
    } catch (err) {
      console.error('❌ Error marking attendance:', err);
      setIsModalOpen(false);
      setFormData({
        date: new Date().toISOString().split('T')[0],
        checkIn: '',
        checkOut: '',
      });
      alert(err.response?.data?.message || 'Error marking attendance');
    }
  };

  const getStatusBadge = (status) => {
    const statusClasses = {
      'Present': 'status-approved',
      'Delayed': 'status-pending',
      'Late': 'status-pending',
      'Absent': 'status-rejected',
      'On Leave': 'status-rejected',
      'Half Day': 'status-pending',
      'Pending': 'status-pending',
      'Not Checked In': 'status-pending'
    };
    
    return (
      <span className={`status-badge ${statusClasses[status] || 'status-pending'}`}>
        {status}
      </span>
    );
  };

  // FIXED: Filter attendance safely
  const filteredAttendance = filterStatus === 'All' 
    ? attendance 
    : attendance.filter(record => record.status === filterStatus);

  // FIXED: Remove duplicate dates safely
  const uniqueAttendance = Array.from(
    filteredAttendance.reduce((map, record) => {
      if (record && record.date) {
        const dateKey = new Date(record.date).toDateString();
        if (!map.has(dateKey) || (record.checkIn && record.checkIn !== '--')) {
          map.set(dateKey, record);
        }
      }
      return map;
    }, new Map())
  ).map(([_, record]) => record);

const handleQuickCheckIn = async () => {
    try {
        // console.log('📝 Attempting check-in...');
        
        const attendanceData = {
            type: 'check_in',
            date: new Date().toISOString().split('T')[0]
        };
        
        // console.log('📤 Sending data:', attendanceData);
        
        const response = await attendanceAPI.markMyAttendance(attendanceData);
        
        // console.log('📥 Response:', response.data);
        
        if (response.data.success) {
            await fetchAttendanceHistory();
            alert('Check-in successful!');
        } else {
            alert(response.data.message || 'Failed to check in');
        }
    } catch (err) {
        console.error('❌ Error during check_in:', err);
        console.error('Error response:', err.response?.data);
        alert(err.response?.data?.message || err.message || 'Error during check-in');
    }
};

  const handleQuickCheckOut = async () => {
    try {
      const attendanceData = {
        type: 'check_out',
        date: new Date().toISOString().split('T')[0]
      };

      const response = await attendanceAPI.markMyAttendance(attendanceData);
      
      if (response.data.success) {
        await fetchAttendanceHistory();
        alert('Check-out successful!');
      } else {
        alert(response.data.message || 'Failed to check out');
      }
    } catch (err) {
      console.error('❌ Error during check_out:', err);
      alert(err.response?.data?.message || 'Error during check-out');
    }
  };

  if (loading) {
    return (
      <div className="attendance-section">
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Loading attendance data...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="attendance-section">
        <div className="error-container">
          <p className="error-message">{error}</p>
          <button onClick={fetchAttendanceHistory} className="retry-btn">
            Retry
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="attendance-section">
      <div className="attendance-header">
        <h2>Attendance Management</h2>
        <div className="attendance-actions">
          <button 
            className="face-recognition-btn"
            onClick={handleFaceRecognitionAttendance}
            disabled={isCameraOpen}
          >
            <span className="btn-icon">👤</span>
            Face Verification
          </button>
         
          <button 
            className="check-in-btn"
            onClick={handleQuickCheckIn}
          >
            📍 Quick Check In
          </button>
          <button 
            className="check-out-btn"
            onClick={handleQuickCheckOut}
          >
            🏠 Quick Check Out
          </button>
      
          <button 
            className="add-attendance-btn"
            onClick={() => setIsModalOpen(true)}
          >
            <span className="btn-icon">+</span>
            Manual Entry
          </button>
        </div>
      </div>

      {/* Attendance Statistics */}
      <div className="attendance-stats">
        <div className="stat-card">
          <h3>Total Records</h3>
          <p className="stat-number">{uniqueAttendance.length}</p>
        </div>
        <div className="stat-card">
          <h3>Present Days</h3>
          <p className="stat-number present">
            {uniqueAttendance.filter(record => 
              record.status === 'Present' || 
              record.status === 'Delayed' || 
              record.status === 'Late'
            ).length}
          </p>
        </div>
        <div className="stat-card">
          <h3>Absent Days</h3>
          <p className="stat-number absent">
            {uniqueAttendance.filter(record => 
              record.status === 'Absent' || 
              record.status === 'On Leave'
            ).length}
          </p>
        </div>
        <div className="stat-card">
          <h3>Face Verified Today</h3>
          <p className="stat-number">
            {uniqueAttendance.filter(record => {
              const today = new Date().toISOString().split('T')[0];
              const recordDate = record.date ? new Date(record.date).toISOString().split('T')[0] : '';
              return recordDate === today && 
                record.remarks && record.remarks.includes('Face');
            }).length}
          </p>
        </div>
      </div>

      {/* Face Verification Modal */}
      {isCameraOpen && (
        <div className="modal-overlay">
          <div className="modal-content camera-modal">
            <div className="modal-header">
              <h2>
                {faceVerificationStep === 'pin-required' 
                  ? '🔒 Additional Verification Required' 
                  : 'Face Verification Attendance'}
              </h2>
              <button 
                className="close-btn"
                onClick={stopCamera}
              >
                ×
              </button>
            </div>
            
            {verificationResult && (
              <div className={`verification-result ${verificationResult.success ? 'success' : 'error'}`}>
                <div className="result-icon">
                  {verificationResult.success ? '✅' : '⚠️'}
                </div>
                <div className="result-message">
                  <p>{verificationResult.message}</p>
                  {verificationResult.details && (
                    <div className="result-details">
                      <p><strong>Status:</strong> {verificationResult.details.status}</p>
                      <p><strong>Check-in Time:</strong> {verificationResult.details.checkIn}</p>
                      {verificationResult.details.shift && (
                        <p><strong>Shift:</strong> {verificationResult.details.shift}</p>
                      )}
                      {verificationResult.details.confidence && (
                        <p><strong>Confidence:</strong> {verificationResult.details.confidence}</p>
                      )}
                    </div>
                  )}
                </div>
              </div>
            )}

            {faceVerificationStep === 'camera' ? (
              <div className="camera-container">
                <div className="camera-preview">
                  <video
                    ref={videoRef}
                    autoPlay
                    playsInline
                    muted
                    className="camera-video"
                  />
                  <canvas ref={canvasRef} style={{ display: 'none' }} />
                  <div className="face-guide-frame">
                    <div className="guide-text">Position your face in the frame</div>
                  </div>
                </div>
                <div className="camera-controls">
                  <button 
                    onClick={captureAndVerify}
                    disabled={faceRecognitionLoading || verificationResult?.success}
                    className="capture-btn"
                  >
                    {faceRecognitionLoading ? 'Verifying Face...' : 'Capture & Verify Face'}
                  </button>
                  <button 
                    onClick={stopCamera}
                    className="cancel-btn"
                  >
                    Cancel
                  </button>
                </div>
                <div className="camera-instructions">
                  <p>📸 Ensure good lighting and face the camera directly</p>
                  <p>✅ Remove sunglasses or hats for better recognition</p>
                  <p>⚡ This only checks against your enrolled face (fast & secure)</p>
                </div>
              </div>
            ) : faceVerificationStep === 'pin-required' ? (
              <div className="pin-verification-container">
                <div className="pin-header">
                  <div className="pin-icon">🔒</div>
                  <h3>Additional Security Check</h3>
                  <p className="pin-subtitle">
                    Low confidence match. Please enter your PIN for verification.
                  </p>
                </div>
                
                <div className="pin-input-container">
                  <input
                    type="password"
                    className="pin-input"
                    placeholder="Enter 4-digit PIN"
                    value={pin}
                    onChange={(e) => setPin(e.target.value.replace(/\D/g, '').slice(0, 4))}
                    maxLength={4}
                    disabled={faceRecognitionLoading}
                  />
                  <div className="pin-hint">
                    Enter your 4-digit security PIN
                  </div>
                </div>
                
                <div className="pin-actions">
                  <button
                    onClick={handlePINVerification}
                    disabled={faceRecognitionLoading || pin.length !== 4}
                    className="pin-submit-btn"
                  >
                    {faceRecognitionLoading ? 'Verifying...' : 'Verify PIN & Mark Attendance'}
                  </button>
                  <button
                    onClick={stopCamera}
                    className="pin-cancel-btn"
                    disabled={faceRecognitionLoading}
                  >
                    Cancel
                  </button>
                </div>
                
                <div className="pin-security-note">
                  <p>⚠️ <strong>Security Note:</strong> Face match confidence was low.</p>
                  <p>PIN verification ensures only you can mark your attendance.</p>
                </div>
              </div>
            ) : null}
          </div>
        </div>
      )}

      <div className="attendance-table-container glass-form">
        <div className="table-header">
          <h3>Attendance History</h3>
          <div className="table-actions">
            <select 
              className="filter-btn"
              value={filterStatus}
              onChange={(e) => setFilterStatus(e.target.value)}
            >
              <option value="All">All Status</option>
              <option value="Present">Present</option>
              <option value="Delayed">Delayed</option>
              <option value="Late">Late</option>
              <option value="Absent">Absent</option>
              <option value="On Leave">On Leave</option>
            
            </select>
          </div>
        </div>
        
        {uniqueAttendance.length === 0 ? (
          <div className="no-data">
            <p>No attendance records found</p>
            <button onClick={fetchAttendanceHistory} className="retry-btn">
              Refresh Data
            </button>
          </div>
        ) : (
          <table className="attendance-table">
            <thead>
              <tr>
                <th>Date</th>
                <th>Check In</th>
                <th>Check Out</th>
                <th>Status</th>
                <th>Method</th>
              </tr>
            </thead>
            <tbody>
              {uniqueAttendance.map(record => (
                <tr key={record.id}>
                  <td>
                    <div className="date-cell">
                      {record.date ? new Date(record.date).toLocaleDateString('en-US', {
                        weekday: 'short',
                        year: 'numeric',
                        month: 'short',
                        day: 'numeric'
                      }) : 'N/A'}
                    </div>
                  </td>
                  <td>
                    <div className="time-cell">
                      {record.checkIn}
                    </div>
                  </td>
                  <td>
                    <div className="time-cell">
                      {record.checkOut}
                    </div>
                  </td>
                  <td>
                    {getStatusBadge(record.status)}
                  </td>
                  <td>
                    <div className="method-cell">
                      {record.remarks && record.remarks.includes('Face') ? (
                        <span className="method-badge face-method">👤 Face</span>
                      ) : record.remarks && record.remarks.includes('PIN') ? (
                        <span className="method-badge pin-method">🔒 PIN</span>
                      ) : (
                        <span className="method-badge manual-method">✏️ Manual</span>
                      )}
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      {/* Manual Entry Modal */}
      {isModalOpen && (
        <div className="modal-overlay">
          <div className="modal-content">
            <div className="modal-header">
              <h2>Add Attendance Record</h2>
              <button 
                className="close-btn"
                onClick={() => setIsModalOpen(false)}
              >
                ×
              </button>
            </div>

            <form onSubmit={handleSubmit} className="attendance-form">
              <div className="form-group">
                <label>Date *</label>
                <input
                  type="date"
                  name="date"
                  value={formData.date}
                  onChange={handleInputChange}
                  required
                  max={new Date().toISOString().split('T')[0]}
                />
              </div>

              <div className="time-inputs">
                <div className="form-group">
                  <label>Check In Time</label>
                  <input
                    type="time"
                    name="checkIn"
                    value={formData.checkIn}
                    onChange={handleInputChange}
                  />
                  <small className="helper-text">Leave empty if absent</small>
                </div>

                <div className="form-group">
                  <label>Check Out Time</label>
                  <input
                    type="time"
                    name="checkOut"
                    value={formData.checkOut}
                    onChange={handleInputChange}
                  />
                  <small className="helper-text">Leave empty if absent</small>
                </div>
              </div>

              <div className="form-actions">
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="cancel-btn"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="submit-btn"
                >
                  Add Record
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default AttendanceTable;