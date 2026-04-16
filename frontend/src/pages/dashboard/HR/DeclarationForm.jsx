import React, { useState, useEffect } from 'react';
import { employeeAPI } from '../../../services/employeeAPI';
import companyLogo from "../../../assets/img/company.png";
import stampPng from "../../../assets/img/stamp.png";
import { 
  HiOutlineArrowDownTray,
  HiOutlineDocumentText,
  HiOutlineEye,
  HiOutlinePencil,
  HiOutlineTrash,
  HiOutlinePlus
} from "react-icons/hi2";
import './DeclarationForm.css';
import pfDeclarationPDFService from '../../../services/pfDeclarationPDFService';
import brandingAPI from '../../../services/brandingAPI';
import declarationFormAPI from '../../../services/declarationFormAPI';

const DeclarationForm = () => {
  const [employees, setEmployees] = useState([]);
  const [selectedEmployeeId, setSelectedEmployeeId] = useState("");
  const [isGenerating, setIsGenerating] = useState(false);
  const [savedForms, setSavedForms] = useState([]);
  const [showModal, setShowModal] = useState(false);
  const [editingForm, setEditingForm] = useState(null);
  const [loading, setLoading] = useState(true);
  
  const companyId = localStorage.getItem('companyId') || '1';

  const [formData, setFormData] = useState({
    nameOfMember: "",
    fatherName: "",
    spouseName: "",
    selectedRelation: "father",
    dateOfBirth: "",
    gender: "",
    maritalStatus: "",
    emailId: "",
    mobileNo: "",
    wasEPFMember: "",
    wasEPSMember: "",
    previousUAN: "",
    previousPFAccount: "",
    previousExitDate: "",
    schemeCertificateNo: "",
    ppoNo: "",
    isInternationalWorker: "",
    countryOfOrigin: "India",
    otherCountry: "",
    passportNo: "",
    passportValidFrom: "",
    passportValidTo: "",
    bankAccountNo: "",
    ifscCode: "",
    aadharNumber: "",
    panNumber: "",
    undertakingDate: new Date().toISOString().split('T')[0],
    undertakingPlace: "",
    memberSalutation: "Mr.",
    joiningDate: "",
    pfNumber: "",
    uanNumber: "",
    kycStatus: "",
    transferRequestGenerated: "",
    employerDate: new Date().toISOString().split('T')[0],
    undertakingCheck1: true,
    undertakingCheck2: true,
    undertakingCheck3: true,
    undertakingCheck4: true,
    declarationCheckA: true,
    declarationCheckB: true,
    declarationCheckC: true,
    undertakingText1: "Certified that the particulars are true to the best of my knowledge.",
    undertakingText2: "I authorize EPFO to use my Aadhar for verification/authentication/KYC purpose for service delivery.",
    undertakingText3: "Kindly transfer the funds and service details, if applicable, from the previous PF account as declared above to the present P.F. Account.",
    undertakingText4: "In case of changes in above details, the same will be intimate to employer at the earliest.",
    declarationTextA: "",
    declarationTextB: "",
    declarationTextC: ""
  });

  const [branding, setBranding] = useState({
    company_name: "Arham IT Solution",
    company_address: "Above Being Healthy Gym",
    company_email: "info@arhamitsolution.in",
    company_website: "www.arhamitsolution.in",
    hr_name: "Sharjeel Iqbal",
    hr_designation: "HR and BDE Executive",
    logo_url: companyLogo,
    stamp_url: stampPng,
    signature_url: null
  });

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      try {
        const [employeesRes, brandingRes, formsRes] = await Promise.all([
          employeeAPI.getAll(),
          brandingAPI.get(),
          declarationFormAPI.getAll(companyId)
        ]);
        
        let employeesData = [];
        if (employeesRes.data?.employees) {
          employeesData = employeesRes.data.employees;
        } else if (employeesRes.data?.data) {
          employeesData = employeesRes.data.data;
        } else if (Array.isArray(employeesRes.data)) {
          employeesData = employeesRes.data;
        }
        
        const normalizedEmployees = employeesData.map(emp => ({
          id: emp.employee_id || emp.id,
          employee_id: emp.employee_id || emp.id,
          first_name: emp.first_name || '',
          last_name: emp.last_name || '',
          email: emp.email || '',
          phone: emp.phone || emp.mobile || '',
          date_of_birth: emp.date_of_birth || '',
          gender: emp.gender || '',
          marital_status: emp.marital_status || '',
          father_name: emp.father_name || ''
        }));
        
        setEmployees(normalizedEmployees);
        
        if (brandingRes.data?.success && brandingRes.data?.branding) {
          const b = brandingRes.data.branding;
          setBranding(prev => ({
            ...prev,
            company_name: b.company_name || prev.company_name,
            company_address: b.company_address || prev.company_address,
            company_email: b.company_email || prev.company_email,
            company_website: b.company_website || prev.company_website,
            hr_name: b.hr_name || prev.hr_name,
            hr_designation: b.hr_designation || prev.hr_designation,
            logo_url: b.logo_url ? brandingAPI.getImageUrl(b.logo_url) : prev.logo_url,
            stamp_url: b.stamp_url ? brandingAPI.getImageUrl(b.stamp_url) : prev.stamp_url
          }));
        }
        
        setSavedForms(formsRes.data?.data || []);
      } catch (err) {
        console.error("Error fetching data:", err);
      } finally {
        setLoading(false);
      }
    };
    
    fetchData();
  }, []);

  const handleInputChange = (field, value) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  const handleCheckboxChange = (field, checked) => {
    setFormData(prev => ({ ...prev, [field]: checked }));
  };

  const handleEmployeeSelect = (employeeId) => {
    const match = employees.find(emp => String(emp.id || emp.employee_id) === String(employeeId));
    
    if (match) {
      setSelectedEmployeeId(employeeId);
      setFormData(prev => ({
        ...prev,
        nameOfMember: `${match.first_name || ''} ${match.last_name || ''}`.trim(),
        emailId: match.email || "",
        mobileNo: match.phone || "",
        dateOfBirth: match.date_of_birth || "",
        gender: match.gender || "",
        maritalStatus: match.marital_status || "",
        fatherName: match.father_name || ""
      }));
    }
  };

  const validateForm = () => {
    if (!formData.nameOfMember.trim()) return "Name of member is required";
    if (!formData.dateOfBirth) return "Date of birth is required";
    if (!formData.emailId.trim()) return "Email ID is required";
    if (!formData.mobileNo.trim()) return "Mobile number is required";
    if (!formData.aadharNumber.trim()) return "Aadhar number is required";
    if (formData.aadharNumber.length !== 12) return "Aadhar number must be 12 digits";
    return null;
  };

  const handleSave = async () => {
    const error = validateForm();
    if (error) {
      alert(error);
      return;
    }
    
    if (!selectedEmployeeId) {
      alert("Please select an employee");
      return;
    }

    setIsGenerating(true);
    try {
      await declarationFormAPI.save({
        employee_id: Number(selectedEmployeeId),
        company_id: companyId,
        form_data: formData,
        issue_date: new Date().toISOString().split('T')[0]
      });
      
      alert("Form saved successfully!");
      const res = await declarationFormAPI.getAll(companyId);
      setSavedForms(res.data?.data || []);
      setShowModal(false);
      resetForm();
    } catch (err) {
      console.error("Error saving:", err);
      alert("Failed to save");
    } finally {
      setIsGenerating(false);
    }
  };

  const handleViewPDF = async (formDataToView) => {
    setIsGenerating(true);
    try {
      const pdfBlob = await pfDeclarationPDFService.generatePDFBlob({ ...formDataToView, branding });
      const url = URL.createObjectURL(pdfBlob);
      window.open(url, '_blank');
      setTimeout(() => URL.revokeObjectURL(url), 1000);
    } catch (err) {
      console.error("Error generating PDF:", err);
      alert("Failed to generate PDF");
    } finally {
      setIsGenerating(false);
    }
  };

  const handleDownload = async (formDataToDownload) => {
    setIsGenerating(true);
    try {
      await pfDeclarationPDFService.downloadPFDeclaration({ ...formDataToDownload, branding });
    } catch (err) {
      console.error("Error generating PDF:", err);
      alert("Failed to generate PDF");
    } finally {
      setIsGenerating(false);
    }
  };

  const resetForm = () => {
    setFormData({
      nameOfMember: "",
      fatherName: "",
      spouseName: "",
      selectedRelation: "father",
      dateOfBirth: "",
      gender: "",
      maritalStatus: "",
      emailId: "",
      mobileNo: "",
      wasEPFMember: "",
      wasEPSMember: "",
      previousUAN: "",
      previousPFAccount: "",
      previousExitDate: "",
      schemeCertificateNo: "",
      ppoNo: "",
      isInternationalWorker: "",
      countryOfOrigin: "India",
      otherCountry: "",
      passportNo: "",
      passportValidFrom: "",
      passportValidTo: "",
      bankAccountNo: "",
      ifscCode: "",
      aadharNumber: "",
      panNumber: "",
      undertakingDate: new Date().toISOString().split('T')[0],
      undertakingPlace: "",
      memberSalutation: "Mr.",
      joiningDate: "",
      pfNumber: "",
      uanNumber: "",
      kycStatus: "",
      transferRequestGenerated: "",
      employerDate: new Date().toISOString().split('T')[0],
      undertakingCheck1: true,
      undertakingCheck2: true,
      undertakingCheck3: true,
      undertakingCheck4: true,
      declarationCheckA: true,
      declarationCheckB: true,
      declarationCheckC: true,
      undertakingText1: "Certified that the particulars are true to the best of my knowledge.",
      undertakingText2: "I authorize EPFO to use my Aadhar for verification/authentication/KYC purpose for service delivery.",
      undertakingText3: "Kindly transfer the funds and service details, if applicable, from the previous PF account as declared above to the present P.F. Account.",
      undertakingText4: "In case of changes in above details, the same will be intimate to employer at the earliest.",
      declarationTextA: "",
      declarationTextB: "",
      declarationTextC: ""
    });
    setSelectedEmployeeId("");
    setEditingForm(null);
  };

  const handleEdit = (form) => {
    setFormData(form.form_data);
    setSelectedEmployeeId(form.employee_id);
    setEditingForm(form);
    setShowModal(true);
  };

  const handleDelete = async (id) => {
    if (window.confirm('Are you sure you want to delete this form?')) {
      try {
        await declarationFormAPI.delete(id);
        const res = await declarationFormAPI.getAll(companyId);
        setSavedForms(res.data?.data || []);
        alert('Deleted successfully');
      } catch (err) {
        alert('Failed to delete');
      }
    }
  };

  const formatDate = (dateString) => {
    if (!dateString) return '';
    return new Date(dateString).toLocaleDateString('en-GB');
  };

  return (
    <div style={{ padding: "30px", background: "#f8fafc", minHeight: "100vh" }}>
      {/* Header */}
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "20px" }}>
        <h2 style={{ fontSize: "24px", fontWeight: "bold", color: "#1e293b", display: "flex", alignItems: "center", gap: "10px", margin: 0 }}>
          <HiOutlineDocumentText size={28} color="#4f46e5" />
          EPF Form 11 (Revised)
        </h2>
        <button 
          onClick={() => { resetForm(); setShowModal(true); }} 
          style={{ background: "#4f46e5", color: "white", border: "none", padding: "10px 20px", borderRadius: "8px", fontWeight: "bold", cursor: "pointer", display: "flex", alignItems: "center", gap: "8px" }}
        >
          <HiOutlinePlus size={20} /> Add Information
        </button>
      </div>

      {/* Table */}
      <div style={{ background: "white", borderRadius: "12px", boxShadow: "0 4px 6px rgba(0,0,0,0.05)", overflow: "hidden" }}>
        <table style={{ width: "100%", borderCollapse: "collapse", textAlign: "left" }}>
          <thead>
            <tr style={{ background: "#f1f5f9", color: "#475569", fontSize: "0.9rem" }}>
              <th style={{ padding: "16px", borderBottom: "1px solid #e2e8f0" }}>Member Name</th>
              <th style={{ padding: "16px", borderBottom: "1px solid #e2e8f0" }}>Email</th>
              <th style={{ padding: "16px", borderBottom: "1px solid #e2e8f0" }}>Mobile</th>
              <th style={{ padding: "16px", borderBottom: "1px solid #e2e8f0" }}>AADHAR</th>
              <th style={{ padding: "16px", borderBottom: "1px solid #e2e8f0" }}>Created Date</th>
              <th style={{ padding: "16px", borderBottom: "1px solid #e2e8f0", textAlign: "center" }}>Actions</th>
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <tr>
                <td colSpan="6" style={{ textAlign: "center", padding: "40px", color: "#64748b" }}>Loading...</td>
              </tr>
            ) : savedForms.length > 0 ? (
              savedForms.map(form => (
                <tr key={form.id} style={{ borderBottom: "1px solid #f1f5f9" }}>
                  <td style={{ padding: "16px", fontWeight: "bold", color: "#334155" }}>{form.form_data?.nameOfMember || 'N/A'}</td>
                  <td style={{ padding: "16px", color: "#64748b" }}>{form.form_data?.emailId || 'N/A'}</td>
                  <td style={{ padding: "16px", color: "#64748b" }}>{form.form_data?.mobileNo || 'N/A'}</td>
                  <td style={{ padding: "16px", color: "#64748b" }}>{form.form_data?.aadharNumber ? `****${form.form_data.aadharNumber.slice(-4)}` : 'N/A'}</td>
                  <td style={{ padding: "16px", color: "#64748b" }}>{new Date(form.created_at).toLocaleDateString('en-GB')}</td>
                  <td style={{ padding: "16px", textAlign: "center" }}>
                    <div style={{ display: "flex", justifyContent: "center", gap: "8px" }}>
                      <button 
                        onClick={() => handleViewPDF(form.form_data)} 
                        title="View PDF" 
                        style={{ padding: "6px", background: "#f1f5f9", border: "none", borderRadius: "4px", cursor: "pointer", color: "#4f46e5" }}
                        disabled={isGenerating}
                      >
                        <HiOutlineEye size={18} />
                      </button>
                      <button 
                        onClick={() => handleDownload(form.form_data)} 
                        title="Download PDF" 
                        style={{ padding: "6px", background: "#f1f5f9", border: "none", borderRadius: "4px", cursor: "pointer", color: "#10b981" }}
                        disabled={isGenerating}
                      >
                        <HiOutlineArrowDownTray size={18} />
                      </button>
                      <button onClick={() => handleEdit(form)} title="Edit" style={{ padding: "6px", background: "#f1f5f9", border: "none", borderRadius: "4px", cursor: "pointer", color: "#f59e0b" }}>
                        <HiOutlinePencil size={18} />
                      </button>
                      <button onClick={() => handleDelete(form.id)} title="Delete" style={{ padding: "6px", background: "#f1f5f9", border: "none", borderRadius: "4px", cursor: "pointer", color: "#b91c1c" }}>
                        <HiOutlineTrash size={18} />
                      </button>
                    </div>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan="6" style={{ textAlign: "center", padding: "40px", color: "#64748b" }}>No forms found. Click "Add Information" to create a new EPF declaration form.</td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

     {/* Modal for Add/Edit Form */}
{showModal && (
  <div style={{ position: "fixed", top: 0, left: 0, right: 0, bottom: 0, background: "rgba(0,0,0,0.5)", display: "flex", justifyContent: "center", alignItems: "center", zIndex: 9999 }}>
    <div style={{ background: "white", padding: "24px", borderRadius: "12px", width: "900px", maxWidth: "95%", maxHeight: "90vh", overflowY: "auto" }}>
      <h3 style={{ margin: "0 0 20px 0", color: "#1e293b", borderBottom: "1px solid #e2e8f0", paddingBottom: "10px" }}>
        {editingForm ? "Edit EPF Declaration Form" : "Add New EPF Declaration Form"}
      </h3>
      
      <form onSubmit={(e) => { e.preventDefault(); handleSave(); }}>
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "16px", marginBottom: "16px" }}>
          {/* Select Employee */}
          <div style={{ gridColumn: "span 2" }}>
            <label style={{ display: "block", marginBottom: "8px", fontWeight: "bold", fontSize: "14px", color: "#334155" }}>Select Employee *</label>
            <select 
              required 
              style={{ width: "100%", padding: "8px 12px", borderRadius: "6px", border: "1px solid #cbd5e1" }} 
              value={selectedEmployeeId} 
              onChange={(e) => handleEmployeeSelect(e.target.value)}
            >
              <option value="">-- Select Employee --</option>
              {employees.map(emp => {
                const empId = emp.id || emp.employee_id;
                return (
                  <option key={empId} value={empId}>
                    {emp.first_name} {emp.last_name} ({emp.email})
                  </option>
                );
              })}
            </select>
          </div>

          {/* Name of Member */}
          <div style={{ gridColumn: "span 2" }}>
            <label style={{ display: "block", marginBottom: "8px", fontWeight: "bold", fontSize: "14px" }}>1. Name of the member *</label>
            <input 
              type="text" 
              required
              style={{ width: "100%", padding: "8px", borderRadius: "6px", border: "1px solid #cbd5e1" }} 
              value={formData.nameOfMember}
              onChange={(e) => handleInputChange('nameOfMember', e.target.value)}
            />
          </div>

          {/* Father's / Spouse's Name */}
          <div style={{ gridColumn: "span 2" }}>
            <label style={{ display: "block", marginBottom: "8px", fontWeight: "bold", fontSize: "14px" }}>2. Father's / Spouse's Name</label>
            <div style={{ display: "flex", gap: "16px", marginBottom: "8px" }}>
              <label>
                <input 
                  type="radio" 
                  name="relation" 
                  value="father" 
                  checked={formData.selectedRelation === 'father'} 
                  onChange={() => handleInputChange('selectedRelation', 'father')} 
                /> Father
              </label>
              <label>
                <input 
                  type="radio" 
                  name="relation" 
                  value="spouse" 
                  checked={formData.selectedRelation === 'spouse'} 
                  onChange={() => handleInputChange('selectedRelation', 'spouse')} 
                /> Spouse
              </label>
            </div>
            <input 
              type="text" 
              style={{ width: "100%", padding: "8px", borderRadius: "6px", border: "1px solid #cbd5e1" }} 
              placeholder={formData.selectedRelation === 'father' ? "Father's name" : "Spouse's name"}
              value={formData.selectedRelation === 'father' ? formData.fatherName : formData.spouseName}
              onChange={(e) => handleInputChange(formData.selectedRelation === 'father' ? 'fatherName' : 'spouseName', e.target.value)}
            />
          </div>

          {/* Date of Birth, Gender, Marital Status */}
          <div>
            <label style={{ display: "block", marginBottom: "8px", fontWeight: "bold", fontSize: "14px" }}>3. Date of Birth *</label>
            <input type="date" required style={{ width: "100%", padding: "8px", borderRadius: "6px", border: "1px solid #cbd5e1" }} value={formData.dateOfBirth} onChange={(e) => handleInputChange('dateOfBirth', e.target.value)} />
          </div>
          <div>
            <label style={{ display: "block", marginBottom: "8px", fontWeight: "bold", fontSize: "14px" }}>4. Gender</label>
            <select style={{ width: "100%", padding: "8px", borderRadius: "6px", border: "1px solid #cbd5e1" }} value={formData.gender} onChange={(e) => handleInputChange('gender', e.target.value)}>
              <option value="">Select</option>
              <option value="Male">Male</option>
              <option value="Female">Female</option>
              <option value="Transgender">Transgender</option>
            </select>
          </div>
          <div>
            <label style={{ display: "block", marginBottom: "8px", fontWeight: "bold", fontSize: "14px" }}>5. Marital Status</label>
            <select style={{ width: "100%", padding: "8px", borderRadius: "6px", border: "1px solid #cbd5e1" }} value={formData.maritalStatus} onChange={(e) => handleInputChange('maritalStatus', e.target.value)}>
              <option value="">Select</option>
              <option value="Married">Married</option>
              <option value="Unmarried">Unmarried</option>
              <option value="Widow">Widow</option>
              <option value="Widower">Widower</option>
              <option value="Divorce">Divorce</option>
            </select>
          </div>

          {/* Email and Mobile */}
          <div>
            <label style={{ display: "block", marginBottom: "8px", fontWeight: "bold", fontSize: "14px" }}>6(a). Email ID *</label>
            <input type="email" required style={{ width: "100%", padding: "8px", borderRadius: "6px", border: "1px solid #cbd5e1" }} value={formData.emailId} onChange={(e) => handleInputChange('emailId', e.target.value)} />
          </div>
          <div>
            <label style={{ display: "block", marginBottom: "8px", fontWeight: "bold", fontSize: "14px" }}>6(b). Mobile No. *</label>
            <input type="tel" required style={{ width: "100%", padding: "8px", borderRadius: "6px", border: "1px solid #cbd5e1" }} value={formData.mobileNo} onChange={(e) => handleInputChange('mobileNo', e.target.value)} />
          </div>

          {/* AADHAR and PAN */}
          <div>
            <label style={{ display: "block", marginBottom: "8px", fontWeight: "bold", fontSize: "14px" }}>AADHAR Number *</label>
            <input type="text" required placeholder="12 digits" style={{ width: "100%", padding: "8px", borderRadius: "6px", border: "1px solid #cbd5e1" }} value={formData.aadharNumber} onChange={(e) => handleInputChange('aadharNumber', e.target.value)} />
          </div>
          <div>
            <label style={{ display: "block", marginBottom: "8px", fontWeight: "bold", fontSize: "14px" }}>PAN Number</label>
            <input type="text" placeholder="ABCDE1234F" style={{ width: "100%", padding: "8px", borderRadius: "6px", border: "1px solid #cbd5e1" }} value={formData.panNumber} onChange={(e) => handleInputChange('panNumber', e.target.value.toUpperCase())} />
          </div>

          {/* UNDERTAKING SECTION */}
          <div style={{ gridColumn: "span 2", marginTop: "16px", borderTop: "2px solid #4f46e5", paddingTop: "16px", background: "#f8fafc", borderRadius: "8px", padding: "16px" }}>
            <label style={{ display: "block", marginBottom: "12px", fontWeight: "bold", fontSize: "16px", color: "#1e293b" }}>✅ UNDERTAKING</label>
            
            <div style={{ marginBottom: "12px", display: "flex", alignItems: "flex-start", gap: "10px" }}>
              <input 
                type="checkbox" 
                checked={formData.undertakingCheck1}
                onChange={(e) => handleCheckboxChange('undertakingCheck1', e.target.checked)}
                style={{ marginTop: "2px", width: "18px", height: "18px", cursor: "pointer" }}
              />
              <label style={{ fontSize: "13px", color: "#334155", lineHeight: "1.4", cursor: "pointer" }}>
                <strong>1.</strong> {formData.undertakingText1}
              </label>
            </div>
            
            <div style={{ marginBottom: "12px", display: "flex", alignItems: "flex-start", gap: "10px" }}>
              <input 
                type="checkbox" 
                checked={formData.undertakingCheck2}
                onChange={(e) => handleCheckboxChange('undertakingCheck2', e.target.checked)}
                style={{ marginTop: "2px", width: "18px", height: "18px", cursor: "pointer" }}
              />
              <label style={{ fontSize: "13px", color: "#334155", lineHeight: "1.4", cursor: "pointer" }}>
                <strong>2.</strong> {formData.undertakingText2}
              </label>
            </div>
            
            <div style={{ marginBottom: "12px", display: "flex", alignItems: "flex-start", gap: "10px" }}>
              <input 
                type="checkbox" 
                checked={formData.undertakingCheck3}
                onChange={(e) => handleCheckboxChange('undertakingCheck3', e.target.checked)}
                style={{ marginTop: "2px", width: "18px", height: "18px", cursor: "pointer" }}
              />
              <label style={{ fontSize: "13px", color: "#334155", lineHeight: "1.4", cursor: "pointer" }}>
                <strong>3.</strong> {formData.undertakingText3}
              </label>
            </div>
            
            <div style={{ marginBottom: "12px", display: "flex", alignItems: "flex-start", gap: "10px" }}>
              <input 
                type="checkbox" 
                checked={formData.undertakingCheck4}
                onChange={(e) => handleCheckboxChange('undertakingCheck4', e.target.checked)}
                style={{ marginTop: "2px", width: "18px", height: "18px", cursor: "pointer" }}
              />
              <label style={{ fontSize: "13px", color: "#334155", lineHeight: "1.4", cursor: "pointer" }}>
                <strong>4.</strong> {formData.undertakingText4}
              </label>
            </div>
          </div>

          {/* DECLARATION SECTION */}
          <div style={{ gridColumn: "span 2", marginTop: "16px", borderTop: "2px solid #10b981", paddingTop: "16px", background: "#f8fafc", borderRadius: "8px", padding: "16px" }}>
            <label style={{ display: "block", marginBottom: "12px", fontWeight: "bold", fontSize: "16px", color: "#1e293b" }}>📋 DECLARATION BY PRESENT EMPLOYER</label>
            
            <div style={{ marginBottom: "12px", display: "flex", alignItems: "flex-start", gap: "10px" }}>
              <input 
                type="checkbox" 
                checked={formData.declarationCheckA}
                onChange={(e) => handleCheckboxChange('declarationCheckA', e.target.checked)}
                style={{ marginTop: "2px", width: "18px", height: "18px", cursor: "pointer" }}
              />
              <label style={{ fontSize: "13px", color: "#334155", lineHeight: "1.4", cursor: "pointer" }}>
                <strong>A.</strong> The member {formData.memberSalutation || 'Mr./Ms.'} {formData.nameOfMember || '________'} has joined on {formData.joiningDate ? formatDate(formData.joiningDate) : '________'} and has been allotted PF Number <strong>{formData.pfNumber || '________'}</strong>
              </label>
            </div>
            
            <div style={{ marginBottom: "12px", display: "flex", alignItems: "flex-start", gap: "10px" }}>
              <input 
                type="checkbox" 
                checked={formData.declarationCheckB}
                onChange={(e) => handleCheckboxChange('declarationCheckB', e.target.checked)}
                style={{ marginTop: "2px", width: "18px", height: "18px", cursor: "pointer" }}
              />
              <label style={{ fontSize: "13px", color: "#334155", lineHeight: "1.4", cursor: "pointer" }}>
                <strong>B.</strong> In case the person was earlier not a member of EPF Scheme, 1952 and EPS, 1995: Post allotment of UAN, the UAN allotted for the member is <strong>{formData.uanNumber || '________'}</strong>
              </label>
            </div>
            
            <div style={{ marginBottom: "12px", display: "flex", alignItems: "flex-start", gap: "10px" }}>
              <input 
                type="checkbox" 
                checked={formData.declarationCheckC}
                onChange={(e) => handleCheckboxChange('declarationCheckC', e.target.checked)}
                style={{ marginTop: "2px", width: "18px", height: "18px", cursor: "pointer" }}
              />
              <label style={{ fontSize: "13px", color: "#334155", lineHeight: "1.4", cursor: "pointer" }}>
                <strong>C.</strong> In case the person was earlier a member of EPF Scheme, 1952 and EPS, 1995: The above PF Account number/UAN of the member has been tagged with his/her UAN/Previous Member ID as declared by member.
              </label>
            </div>
          </div>

          {/* Undertaking Date and Place */}
          <div>
            <label style={{ display: "block", marginBottom: "8px", fontWeight: "bold", fontSize: "14px" }}>Undertaking Date</label>
            <input type="date" style={{ width: "100%", padding: "8px", borderRadius: "6px", border: "1px solid #cbd5e1" }} value={formData.undertakingDate} onChange={(e) => handleInputChange('undertakingDate', e.target.value)} />
          </div>
          <div>
            <label style={{ display: "block", marginBottom: "8px", fontWeight: "bold", fontSize: "14px" }}>Place</label>
            <input type="text" style={{ width: "100%", padding: "8px", borderRadius: "6px", border: "1px solid #cbd5e1" }} value={formData.undertakingPlace} onChange={(e) => handleInputChange('undertakingPlace', e.target.value)} />
          </div>

          {/* PF and UAN Numbers */}
          <div>
            <label style={{ display: "block", marginBottom: "8px", fontWeight: "bold", fontSize: "14px" }}>PF Number</label>
            <input type="text" style={{ width: "100%", padding: "8px", borderRadius: "6px", border: "1px solid #cbd5e1" }} value={formData.pfNumber} onChange={(e) => handleInputChange('pfNumber', e.target.value)} />
          </div>
          <div>
            <label style={{ display: "block", marginBottom: "8px", fontWeight: "bold", fontSize: "14px" }}>UAN Number</label>
            <input type="text" style={{ width: "100%", padding: "8px", borderRadius: "6px", border: "1px solid #cbd5e1" }} value={formData.uanNumber} onChange={(e) => handleInputChange('uanNumber', e.target.value)} />
          </div>

          {/* Joining Date */}
          <div>
            <label style={{ display: "block", marginBottom: "8px", fontWeight: "bold", fontSize: "14px" }}>Joining Date</label>
            <input type="date" style={{ width: "100%", padding: "8px", borderRadius: "6px", border: "1px solid #cbd5e1" }} value={formData.joiningDate} onChange={(e) => handleInputChange('joiningDate', e.target.value)} />
          </div>
          <div>
            <label style={{ display: "block", marginBottom: "8px", fontWeight: "bold", fontSize: "14px" }}>Member Salutation</label>
            <select style={{ width: "100%", padding: "8px", borderRadius: "6px", border: "1px solid #cbd5e1" }} value={formData.memberSalutation} onChange={(e) => handleInputChange('memberSalutation', e.target.value)}>
              <option value="Mr.">Mr.</option>
              <option value="Ms.">Ms.</option>
              <option value="Mrs.">Mrs.</option>
            </select>
          </div>

          {/* KYC STATUS - Radio buttons */}
          <div style={{ gridColumn: "span 2", marginTop: "8px" }}>
            <label style={{ display: "block", marginBottom: "8px", fontWeight: "bold", fontSize: "14px" }}>KYC Status *</label>
            <div style={{ display: "flex", flexDirection: "column", gap: "8px", padding: "8px 0" }}>
              <label style={{ display: "flex", alignItems: "center", gap: "10px", cursor: "pointer" }}>
                <input 
                  type="radio" 
                  name="kycStatus" 
                  value="not_uploaded" 
                  checked={formData.kycStatus === 'not_uploaded'} 
                  onChange={(e) => handleInputChange('kycStatus', e.target.value)}
                  style={{ width: "16px", height: "16px", cursor: "pointer" }}
                />
                <span style={{ fontSize: "13px" }}>Have not been uploaded</span>
              </label>
              <label style={{ display: "flex", alignItems: "center", gap: "10px", cursor: "pointer" }}>
                <input 
                  type="radio" 
                  name="kycStatus" 
                  value="uploaded_not_approved" 
                  checked={formData.kycStatus === 'uploaded_not_approved'} 
                  onChange={(e) => handleInputChange('kycStatus', e.target.value)}
                  style={{ width: "16px", height: "16px", cursor: "pointer" }}
                />
                <span style={{ fontSize: "13px" }}>Have been uploaded but not approved</span>
              </label>
              <label style={{ display: "flex", alignItems: "center", gap: "10px", cursor: "pointer" }}>
                <input 
                  type="radio" 
                  name="kycStatus" 
                  value="uploaded_approved" 
                  checked={formData.kycStatus === 'uploaded_approved'} 
                  onChange={(e) => handleInputChange('kycStatus', e.target.value)}
                  style={{ width: "16px", height: "16px", cursor: "pointer" }}
                />
                <span style={{ fontSize: "13px" }}>Have been uploaded and approved with DSC</span>
              </label>
            </div>
          </div>

          {/* TRANSFER REQUEST GENERATED - Radio buttons */}
          <div style={{ gridColumn: "span 2", marginTop: "8px" }}>
            <label style={{ display: "block", marginBottom: "8px", fontWeight: "bold", fontSize: "14px" }}>Transfer Request Generated *</label>
            <div style={{ display: "flex", gap: "20px", padding: "8px 0" }}>
              <label style={{ display: "flex", alignItems: "center", gap: "8px", cursor: "pointer" }}>
                <input 
                  type="radio" 
                  name="transferRequest" 
                  value="yes" 
                  checked={formData.transferRequestGenerated === 'yes'} 
                  onChange={(e) => handleInputChange('transferRequestGenerated', e.target.value)}
                  style={{ width: "16px", height: "16px", cursor: "pointer" }}
                />
                <span style={{ fontSize: "13px" }}>Yes</span>
              </label>
              <label style={{ display: "flex", alignItems: "center", gap: "8px", cursor: "pointer" }}>
                <input 
                  type="radio" 
                  name="transferRequest" 
                  value="no" 
                  checked={formData.transferRequestGenerated === 'no'} 
                  onChange={(e) => handleInputChange('transferRequestGenerated', e.target.value)}
                  style={{ width: "16px", height: "16px", cursor: "pointer" }}
                />
                <span style={{ fontSize: "13px" }}>No</span>
              </label>
            </div>
          </div>

          {/* Employer Date */}
          <div>
            <label style={{ display: "block", marginBottom: "8px", fontWeight: "bold", fontSize: "14px" }}>Employer Declaration Date</label>
            <input type="date" style={{ width: "100%", padding: "8px", borderRadius: "6px", border: "1px solid #cbd5e1" }} value={formData.employerDate} onChange={(e) => handleInputChange('employerDate', e.target.value)} />
          </div>
        </div>

        <div style={{ display: "flex", justifyContent: "flex-end", gap: "10px", marginTop: "20px" }}>
          <button type="button" onClick={() => { setShowModal(false); resetForm(); }} style={{ padding: "8px 16px", background: "#f1f5f9", color: "#475569", border: "none", borderRadius: "6px", cursor: "pointer" }}>Cancel</button>
          <button type="submit" disabled={isGenerating} style={{ padding: "8px 16px", background: "#4f46e5", color: "white", border: "none", borderRadius: "6px", cursor: "pointer", opacity: isGenerating ? 0.7 : 1 }}>
            {isGenerating ? 'Saving...' : (editingForm ? 'Update Form' : 'Save Form')}
          </button>
        </div>
      </form>
    </div>
  </div>
)}
    </div>
  );
};

export default DeclarationForm;