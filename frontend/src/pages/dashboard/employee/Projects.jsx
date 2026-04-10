import React, { useState, useEffect } from 'react';
import { FaExclamationTriangle, FaBell, FaUsers, FaTasks, FaPlus, FaTrash, FaEye, FaCheck, FaFileExcel, FaUpload, FaCheckCircle, FaHourglassHalf, FaClock, FaUserPlus, FaDownload, FaSync, FaEdit } from 'react-icons/fa';
import { projectAPI } from '../../../services/projectAPI';
import './Projects.css';
import * as XLSX from 'xlsx';

const ProjectManagement = () => {
  // User context
  const [currentUser, setCurrentUser] = useState({
    id: null,
    employeeId: null,
    name: '',
    role: '',
    isProjectLead: false,
    managedProjects: []
  });

  // State variables
  const [projects, setProjects] = useState([]);
  const [projectLeads, setProjectLeads] = useState([]);
  const [departments, setDepartments] = useState([]);
  const [employees, setEmployees] = useState([]);
  const [teams, setTeams] = useState([]);
  const [tasks, setTasks] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [activeTab, setActiveTab] = useState('projects');
  const [selectedEmployees, setSelectedEmployees] = useState([]);
  const [selectedTaskEmployees, setSelectedTaskEmployees] = useState([]);
  const [availableTeamMembers, setAvailableTeamMembers] = useState([]);
  const [loadingTeamMembers, setLoadingTeamMembers] = useState(false);
  const [loadingTeams, setLoadingTeams] = useState(false);

  // Modal states
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isViewModalOpen, setIsViewModalOpen] = useState(false);
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
  const [isPhaseModalOpen, setIsPhaseModalOpen] = useState(false);
  const [isTaskModalOpen, setIsTaskModalOpen] = useState(false);
  const [isTeamModalOpen, setIsTeamModalOpen] = useState(false);
  const [isTaskDetailsModalOpen, setIsTaskDetailsModalOpen] = useState(false);
  const [isDeleteTaskModalOpen, setIsDeleteTaskModalOpen] = useState(false);
  const [isDeleteTeamModalOpen, setIsDeleteTeamModalOpen] = useState(false);
  const [selectedProject, setSelectedProject] = useState(null);
  const [selectedTask, setSelectedTask] = useState(null);
  const [selectedTeam, setSelectedTeam] = useState(null);
  const [selectedPhase, setSelectedPhase] = useState(null);
  const [selectedProjectTeams, setSelectedProjectTeams] = useState([]);
  const [isExcelEditorOpen, setIsExcelEditorOpen] = useState(false);
  const [editableTasks, setEditableTasks] = useState([]);
  const [selectedMonth, setSelectedMonth] = useState(new Date().getMonth());
  const [selectedYear, setSelectedYear] = useState(new Date().getFullYear());
  const [showMonthFilter, setShowMonthFilter] = useState(false);

  // Edit Task Modal State
  const [isEditTaskModalOpen, setIsEditTaskModalOpen] = useState(false);
  const [editTaskData, setEditTaskData] = useState({
    title: '',
    description: '',
    status: '',
    remarks: '',
    priority: '',
    due_date: ''
  });

  // Form states
  const [formData, setFormData] = useState({
    name: '',
    department: '',
    project_lead: '',
    start_date: '',
    end_date: '',
    current_phase: '',
    status: 'On Track',
    description: ''
  });
  
  const [taskFormData, setTaskFormData] = useState({
    title: '',
    description: '',
    priority: 'Medium',
    estimated_hours: 0,
    due_date: '',
    project_id: '',
    team_id: '',
    assigned_to_members: []
  });
  
  const [teamFormData, setTeamFormData] = useState({
    name: '',
    team_lead_id: '',
    project_id: '',
    description: '',
    members: []
  });

  const [phaseFormData, setPhaseFormData] = useState({
    status: '',
    progress: '',
    comments: ''
  });

  const [filters, setFilters] = useState({
    status: '',
    department: ''
  });
  
  const [searchTerm, setSearchTerm] = useState('');
  const [dashboardStats, setDashboardStats] = useState({
    totalProjects: 0,
    activeProjects: 0,
    delayedProjects: 0,
    completedProjects: 0
  });

  const filterTasksByMonth = (tasks, month, year) => {
    return tasks.filter(task => {
      if (!task.created_at && !task.due_date) return true;
      const taskDate = task.created_at ? new Date(task.created_at) : (task.due_date ? new Date(task.due_date) : null);
      if (!taskDate) return true;
      return taskDate.getMonth() === month && taskDate.getFullYear() === year;
    });
  };

  const phases = ['Requirement Specification', 'System Design', 'Development', 'Integration & Testing', 'Deployment', 'Maintenance & Repeat Cycle'];
  const projectStatuses = ['On Track', 'Delayed', 'At Risk', 'Completed', 'On Hold'];
  const taskPriorities = ['High', 'Medium', 'Low'];
  const taskStatuses = ['To-Do', 'In Progress', 'Ready for Review', 'Completed', 'Blocked', 'Cancelled'];
  const reviewStatuses = ['Not Reviewed', 'Approved', 'Rejected', 'Needs Rework'];

  // Check if user can delete task (only Project Lead of that project)
  const canDeleteTask = (task) => {
    if (currentUser.role === 'hr') return true;
    return currentUser.isProjectLead && currentUser.managedProjects.includes(task.project_id);
  };

  // Check if user can delete team (only Project Lead of that project)
  const canDeleteTeam = (team) => {
    if (currentUser.role === 'hr') return true;
    return currentUser.isProjectLead && currentUser.managedProjects.includes(team.project_id);
  };

  // Check if user can edit task
  const canEditTask = (task) => {
    if (currentUser.role === 'hr') return true;
    if (currentUser.isProjectLead && currentUser.managedProjects.includes(task.project_id)) return true;
    return task.assigned_to_member === currentUser.id;
  };

  // Open Edit Task Modal
  const openEditTaskModal = (task) => {
    setSelectedTask(task);
    setEditTaskData({
      title: task.title || '',
      description: task.description || '',
      status: task.status || 'To-Do',
      remarks: task.remarks || '',
      priority: task.priority || 'Medium',
      due_date: task.due_date || ''
    });
    setIsEditTaskModalOpen(true);
  };

  // Handle Edit Task Submit
  const handleEditTaskSubmit = async (e) => {
    e.preventDefault();
    
    if (!selectedTask) return;
    
    try {
      const updateData = {};
      
      if (editTaskData.description !== selectedTask.description) {
        updateData.description = editTaskData.description;
      }
      
      if (editTaskData.status !== selectedTask.status) {
        updateData.status = editTaskData.status;
        if (editTaskData.status === 'Completed') {
          updateData.progress = 100;
          updateData.completed_date = new Date().toISOString().split('T')[0];
        } else if (editTaskData.status === 'In Progress') {
          updateData.progress = 50;
        } else if (editTaskData.status === 'Ready for Review') {
          updateData.progress = 80;
        } else if (editTaskData.status === 'To-Do') {
          updateData.progress = 0;
        } else if (editTaskData.status === 'Blocked') {
          updateData.progress = 0;
        }
      }
      
      if (editTaskData.remarks !== selectedTask.remarks) {
        updateData.remarks = editTaskData.remarks;
      }
      
      if (editTaskData.priority !== selectedTask.priority && canEditTask(selectedTask)) {
        updateData.priority = editTaskData.priority;
      }
      
      if (editTaskData.title !== selectedTask.title && canEditTask(selectedTask)) {
        updateData.title = editTaskData.title;
      }
      
      if (editTaskData.due_date !== selectedTask.due_date) {
        updateData.due_date = editTaskData.due_date;
      }
      
      if (Object.keys(updateData).length > 0) {
        await projectAPI.updateTask(selectedTask.id, updateData);
        await fetchAllData();
        alert('Task updated successfully!');
      } else {
        alert('No changes detected');
      }
      
      setIsEditTaskModalOpen(false);
      setSelectedTask(null);
      setEditTaskData({
        title: '',
        description: '',
        status: '',
        remarks: '',
        priority: '',
        due_date: ''
      });
    } catch (err) {
      console.error('Error updating task:', err);
      alert('Failed to update task: ' + (err.response?.data?.message || err.message));
    }
  };

  // Handle Delete Task
  const handleDeleteTask = async () => {
    if (!selectedTask) return;
    
    if (!canDeleteTask(selectedTask)) {
      alert('Only Project Leads can delete tasks');
      return;
    }
    
    try {
      // Soft delete - update status to 'Cancelled'
      await projectAPI.updateTask(selectedTask.id, { status: 'Cancelled' });
      await fetchAllData();
      setIsDeleteTaskModalOpen(false);
      setSelectedTask(null);
      alert('Task deleted successfully!');
    } catch (err) {
      console.error('Error deleting task:', err);
      alert('Failed to delete task: ' + (err.response?.data?.message || err.message));
    }
  };

  // Handle Delete Team
  const handleDeleteTeam = async () => {
    if (!selectedTeam) return;
    
    if (!canDeleteTeam(selectedTeam)) {
      alert('Only Project Leads can delete teams');
      return;
    }
    
    try {
      await projectAPI.deleteTeam(selectedTeam.id);
      await fetchAllData();
      setIsDeleteTeamModalOpen(false);
      setSelectedTeam(null);
      alert('Team deleted successfully!');
    } catch (err) {
      console.error('Error deleting team:', err);
      alert('Failed to delete team: ' + (err.response?.data?.message || err.message));
    }
  };

  const openExcelEditor = () => {
    if (!selectedProject) {
      alert('Please select a project first from the dropdown above');
      return;
    }
    
    let projectTasks = tasks.filter(task => task.project_id == selectedProject.id);
    
    if (projectTasks.length === 0) {
      alert(`No tasks found for project "${selectedProject.name}". Please create tasks first.`);
      return;
    }
    
    if (showMonthFilter) {
      projectTasks = filterTasksByMonth(projectTasks, selectedMonth, selectedYear);
      if (projectTasks.length === 0) {
        alert(`No tasks found for ${getMonthName(selectedMonth)} ${selectedYear}. Please select a different month or disable the filter.`);
        return;
      }
    }
    
    const daysInMonth = new Date(selectedYear, selectedMonth + 1, 0).getDate();
    const tasksByDate = {};
    
    projectTasks.forEach(task => {
      const taskDate = task.created_at ? new Date(task.created_at) : (task.due_date ? new Date(task.due_date) : new Date());
      const day = taskDate.getDate();
      if (!tasksByDate[day]) {
        tasksByDate[day] = [];
      }
      tasksByDate[day].push(task);
    });
    
    const monthlyTasks = [];
    
    for (let day = 1; day <= daysInMonth; day++) {
      const dateStr = `${selectedYear}-${String(selectedMonth + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
      
      if (tasksByDate[day] && tasksByDate[day].length > 0) {
        tasksByDate[day].forEach(task => {
          monthlyTasks.push({
            id: task.id,
            date: dateStr,
            displayDate: `${day}/${selectedMonth + 1}/${selectedYear}`,
            project: selectedProject.name,
            task: task.title,
            description: task.description || '',
            status: task.status,
            remarks: task.remarks || '',
            priority: task.priority,
            dueDate: task.due_date ? formatDate(task.due_date) : 'Not set',
            assignedTo: task.assigned_to_name || 'Not Assigned'
          });
        });
      } else {
        monthlyTasks.push({
          id: null,
          date: dateStr,
          displayDate: `${day}/${selectedMonth + 1}/${selectedYear}`,
          project: selectedProject.name,
          task: '',
          description: '',
          status: 'To-Do',
          remarks: '',
          priority: 'Medium',
          dueDate: 'Not set',
          assignedTo: ''
        });
      }
    }
    
    setEditableTasks(monthlyTasks);
    setIsExcelEditorOpen(true);
  };
  
  const downloadSheetAsExcel = () => {
    if (!selectedProject) {
      alert('Please select a project first');
      return;
    }
    
    if (editableTasks.length === 0) {
      alert('No data to download');
      return;
    }
    
    const exportData = editableTasks.map(task => ({
      'Date': task.displayDate,
      'Project': task.project,
      'Task/Activity': task.task,
      'Description (What I did)': task.description,
      'Status': task.status,
      'Remarks': task.remarks,
      'Priority': task.priority,
      'Due Date': task.dueDate,
      'Assigned To': task.assignedTo
    }));
    
    const worksheet = XLSX.utils.json_to_sheet(exportData);
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, `Tasks_${selectedProject.name}`);
    
    worksheet['!cols'] = [
      { wch: 15 }, { wch: 25 }, { wch: 30 }, { wch: 40 },
      { wch: 15 }, { wch: 30 }, { wch: 10 }, { wch: 15 }, { wch: 20 }
    ];
    
    const fileName = `${selectedProject.name}_Tasks_${getMonthName(selectedMonth)}_${selectedYear}.xlsx`;
    XLSX.writeFile(workbook, fileName);
    alert(`✅ Sheet downloaded successfully as "${fileName}"`);
  };

  const getMonthName = (month) => {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 
                    'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month];
  };

  const saveExcelEdits = async () => {
    let updatedCount = 0;
    let createdCount = 0;
    let errors = [];
    
    for (const editedTask of editableTasks) {
      const updateData = {};
      
      if (!editedTask.id && editedTask.task && editedTask.task.trim()) {
        try {
          const employeeName = editedTask.assignedTo;
          const employee = employees.find(e => e.name === employeeName);
          
          if (!employee) {
            errors.push(`No employee found for task "${editedTask.task}"`);
            continue;
          }
          
          const taskData = {
            title: editedTask.task.trim(),
            description: editedTask.description || '',
            priority: editedTask.priority || 'Medium',
            due_date: editedTask.date || null,
            project_id: selectedProject.id,
            assigned_by: currentUser.id,
            assigned_by_name: currentUser.name,
            status: editedTask.status || 'To-Do',
            remarks: editedTask.remarks || '',
            assigned_to_member: employee.id
          };
          
          const response = await projectAPI.createTask(taskData);
          if (response.data.success) {
            createdCount++;
          }
        } catch (err) {
          errors.push(`Error creating task "${editedTask.task}": ${err.message}`);
        }
        continue;
      }
      
      const originalTask = tasks.find(t => t.id == editedTask.id);
      if (!originalTask) continue;
      
      if (editedTask.description !== originalTask.description) {
        updateData.description = editedTask.description;
      }
      
      if (editedTask.status !== originalTask.status) {
        updateData.status = editedTask.status;
        if (editedTask.status === 'Completed') {
          updateData.progress = 100;
          updateData.completed_date = new Date().toISOString().split('T')[0];
        } else if (editedTask.status === 'In Progress') {
          updateData.progress = 50;
        } else if (editedTask.status === 'Ready for Review') {
          updateData.progress = 80;
        } else if (editedTask.status === 'To-Do') {
          updateData.progress = 0;
        } else if (editedTask.status === 'Blocked') {
          updateData.progress = 0;
        }
      }
      
      if (editedTask.remarks !== originalTask.remarks) {
        updateData.remarks = editedTask.remarks;
      }
      
      if (Object.keys(updateData).length > 0) {
        try {
          await projectAPI.updateTask(editedTask.id, updateData);
          updatedCount++;
        } catch (err) {
          errors.push(`Task ${editedTask.task}: ${err.message}`);
        }
      }
    }
    
    if (updatedCount > 0 || createdCount > 0) {
      await fetchAllData();
      alert(`✅ Updated: ${updatedCount} tasks | Created: ${createdCount} new tasks`);
      if (errors.length > 0) {
        // console.error('Errors:', errors);
      }
    } else {
      alert('No changes detected');
    }
    
    setIsExcelEditorOpen(false);
    setEditableTasks([]);
  };

  const updateEditableTask = (index, field, value) => {
    const updated = [...editableTasks];
    updated[index][field] = value;
    setEditableTasks(updated);
  };

  // Load current user
  useEffect(() => {
    const loadUser = () => {
      try {
        const userData = JSON.parse(localStorage.getItem('user'));
        if (userData) {
          const userId = userData.employee_id || userData.id || userData.user_id;
          setCurrentUser({
            id: userId,
            employeeId: userId,
            name: userData.name || `${userData.first_name} ${userData.last_name}` || 'User',
            role: userData.role || userData.user_role || 'team_member',
            isProjectLead: false,
            managedProjects: []
          });
        } else {
          setCurrentUser({
            id: 1,
            employeeId: 1,
            name: 'Test User',
            role: 'team_member',
            isProjectLead: false,
            managedProjects: []
          });
        }
      } catch (err) {
        console.error('Error loading user:', err);
      }
    };
    loadUser();
    fetchAllData();
  }, []);
  
  // Set project lead status
  useEffect(() => {
    if (projects.length > 0 && currentUser.name) {
      const managed = projects.filter(p => p.manager === currentUser.name);
      setCurrentUser(prev => ({
        ...prev,
        isProjectLead: managed.length > 0,
        managedProjects: managed.map(p => p.id)
      }));
    }
  }, [projects, currentUser.name]);

  useEffect(() => {
    if (taskFormData.project_id) {
      const projectTeams = teams.filter(t => t.project_id === parseInt(taskFormData.project_id));
      setSelectedProjectTeams(projectTeams);
      setTaskFormData(prev => ({ ...prev, team_id: '' }));
      setAvailableTeamMembers([]);
      setSelectedTaskEmployees([]);
    } else {
      setSelectedProjectTeams([]);
      setAvailableTeamMembers([]);
    }
  }, [taskFormData.project_id, teams]);
  
  useEffect(() => {
    if (taskFormData.team_id) {
      loadTeamMembers(taskFormData.team_id);
    } else {
      setAvailableTeamMembers([]);
      setSelectedTaskEmployees([]);
    }
  }, [taskFormData.team_id]);

  useEffect(() => {
    if (isTaskModalOpen && selectedProject?.id) {
      setTaskFormData(prev => ({
        ...prev,
        project_id: selectedProject.id
      }));
    }
  }, [isTaskModalOpen, selectedProject]);

  const loadTeamMembers = async (teamId) => {
    try {
      setLoadingTeamMembers(true);
      const existingTeam = teams.find(t => t.id === parseInt(teamId));
      
      if (existingTeam && existingTeam.members && existingTeam.members.length > 0) {
        const formattedMembers = existingTeam.members.map(member => ({
          id: member.user_id || member.id,
          user_id: member.user_id || member.id,
          employee_detail_id: member.employee_detail_id || member.employee_id,
          name: member.name,
          position: member.position || 'Team Member',
          email: member.email || ''
        }));
        setAvailableTeamMembers(formattedMembers);
        setLoadingTeamMembers(false);
        return;
      }
      
      const response = await projectAPI.getTeamMembers(teamId);
      let membersList = [];
      
      if (response.data && response.data.success && response.data.data) {
        membersList = response.data.data;
      } else if (response.data && response.data.data && Array.isArray(response.data.data)) {
        membersList = response.data.data;
      } else if (Array.isArray(response.data)) {
        membersList = response.data;
      }
      
      if (membersList.length === 0) {
        setAvailableTeamMembers([]);
        setLoadingTeamMembers(false);
        return;
      }
      
      const formattedMembers = membersList.map(member => ({
        id: member.user_id,
        user_id: member.user_id,
        employee_detail_id: member.employee_detail_id || member.employee_id,
        name: member.name,
        position: member.position || 'Team Member',
        email: member.email || ''
      }));
      
      setAvailableTeamMembers(formattedMembers);
      
      setTeams(prevTeams => 
        prevTeams.map(team => 
          team.id === parseInt(teamId) 
            ? { ...team, members: formattedMembers, member_count: formattedMembers.length }
            : team
        )
      );
      
    } catch (err) {
      console.error('Error fetching team members:', err);
      setAvailableTeamMembers([]);
    } finally {
      setLoadingTeamMembers(false);
    }
  };

  const fetchAllData = async () => {
    try {
      setLoading(true);

      const [projectsRes, statsRes, employeesRes, departmentsRes, teamsRes, tasksRes] = await Promise.allSettled([
        projectAPI.getAll(),
        projectAPI.getStats(),
        projectAPI.getEmployees(),
        projectAPI.getDepartments(),
        projectAPI.getAllTeams(),
        projectAPI.getAllTasks()
      ]);

      if (projectsRes.status === 'fulfilled' && projectsRes.value?.data?.success) {
        setProjects(projectsRes.value.data.data || []);
      } else {
        setProjects([]);
      }

      if (statsRes.status === 'fulfilled' && statsRes.value?.data?.success) {
        setDashboardStats(statsRes.value.data.data || {});
      }

      if (employeesRes.status === 'fulfilled' && employeesRes.value?.data?.success) {
        const employeesData = employeesRes.value.data.data || [];
        const validEmployees = employeesData.filter(emp => emp && emp.id);
        setEmployees(validEmployees);
        
        const leads = validEmployees.filter(emp => {
          const role = emp.role_name?.toLowerCase();
          const position = emp.position?.toLowerCase();
          return role !== 'hr' && position !== 'hr';
        });
        setProjectLeads(leads);
      }

      if (departmentsRes.status === 'fulfilled' && departmentsRes.value?.data?.success) {
        setDepartments(departmentsRes.value.data.data || []);
      }

      if (teamsRes.status === 'fulfilled' && teamsRes.value?.data?.success) {
        const teamsData = teamsRes.value.data.data || [];
        const teamsWithMembers = teamsData.map(team => ({
          ...team,
          members: team.members || [],
          member_count: team.members?.length || 0
        }));
        setTeams(teamsWithMembers);
      }

      if (tasksRes.status === 'fulfilled' && tasksRes.value?.data?.success) {
        setTasks(tasksRes.value.data.data || []);
      } else {
        setTasks([]);
      }

      setError('');
    } catch (err) {
      console.error('Error fetching data:', err);
      setError('Failed to load data. Please refresh the page.');
    } finally {
      setLoading(false);
    }
  };

  const getUserProjects = () => projects;
  const getUserTasks = () => {
    const userIdStr = String(currentUser.id);
    return tasks.filter(t => String(t.assigned_to_member) === userIdStr);
  };

  const canCreateProject = () => currentUser.role === 'hr';
  const canCreateTeam = () => currentUser.isProjectLead;
  const canCreateTask = (projectId) => currentUser.isProjectLead && currentUser.managedProjects.includes(projectId);
  const canEditProject = () => currentUser.role === 'hr';
  const canViewTeamManagement = () => currentUser.isProjectLead;

  const handleEmployeeSelection = (employeeId) => {
    if (!employeeId || employeeId === 'null' || employeeId === 'undefined' || employeeId === '') {
      // console.warn('Invalid employee ID attempted:', employeeId);
      return;
    }
    const id = String(employeeId).trim();
    setSelectedEmployees(prev => 
      prev.includes(id) ? prev.filter(eid => eid !== id) : [...prev, id]
    );
  };

  const handleCreateTeam = async (e) => {
    e.preventDefault();
    
    if (!teamFormData.name) {
      alert('Team name is required');
      return;
    }
    if (!teamFormData.project_id) {
      alert('Please select a project for this team');
      return;
    }
    
    const validMembers = selectedEmployees.filter(id => {
      return id && id !== 'null' && id !== 'undefined' && id !== '' && id !== null;
    });
    
    if (validMembers.length === 0) {
      alert('Please select at least one valid team member');
      return;
    }

    try {
      const teamData = {
        name: teamFormData.name,
        project_id: parseInt(teamFormData.project_id),
        team_lead_id: teamFormData.team_lead_id ? parseInt(teamFormData.team_lead_id) : null,
        description: teamFormData.description || '',
        status: 'Active',
        members: validMembers
      };
      
      const response = await projectAPI.createTeam(teamData);
      
      if (response.data.success) {
        setTeamFormData({ 
          name: '', 
          team_lead_id: '', 
          project_id: '', 
          description: '', 
          members: [] 
        });
        setSelectedEmployees([]);
        setIsTeamModalOpen(false);
        await fetchAllData();
        alert(response.data.message);
        setActiveTab('teams');
      } else {
        alert(response.data.message || 'Failed to create team');
      }
    } catch (error) {
      console.error('Error creating team:', error);
      alert(error.response?.data?.message || 'Failed to create team');
    }
  };

  const handleCreateTask = async (e) => {
    e.preventDefault();
    
    if (!taskFormData.title || !taskFormData.title.trim()) {
      alert('Task title is required');
      return;
    }
    if (!taskFormData.project_id) {
      alert('Project is required');
      return;
    }
    if (selectedTaskEmployees.length === 0) {
      alert('Please select at least one employee to assign this task to');
      return;
    }

    try {
      let createdCount = 0;
      
      for (const userId of selectedTaskEmployees) {
        const numericUserId = Number(userId);
        
        const taskData = {
          title: taskFormData.title.trim(),
          description: taskFormData.description?.trim() || '',
          priority: taskFormData.priority || 'Medium',
          estimated_hours: Number(taskFormData.estimated_hours) || 0,
          due_date: taskFormData.due_date || null,
          project_id: Number(taskFormData.project_id),
          team_id: taskFormData.team_id ? Number(taskFormData.team_id) : null,
          assigned_by: currentUser?.id ? Number(currentUser.id) : null,
          assigned_by_name: currentUser?.name || null,
          status: 'To-Do',
          review_status: 'Not Reviewed',
          progress: 0,
          assigned_to_member: numericUserId
        };
        
        const response = await projectAPI.createTask(taskData);
        
        if (response.data.success) {
          createdCount++;
        }
      }
      
      setTaskFormData({ 
        title: '', 
        description: '', 
        priority: 'Medium', 
        estimated_hours: 0, 
        due_date: '', 
        project_id: selectedProject?.id || '',
        team_id: '',
        assigned_to_members: [] 
      });
      setSelectedTaskEmployees([]);
      setIsTaskModalOpen(false);
      
      await fetchAllData();
      
      if (createdCount > 0) {
        alert(`${createdCount} task(s) created successfully!`);
      } else {
        alert('Failed to create tasks.');
      }
    } catch (err) {
      console.error('Error creating task:', err);
      alert(err.response?.data?.message || 'Failed to create task');
    }
  };

  const handleSubmitProject = async (e) => {
    e.preventDefault();
    if (!canCreateProject()) {
      alert('Only HR can create projects');
      return;
    }
    if (!formData.name || !formData.department || !formData.project_lead) {
      alert('Please fill in all required fields');
      return;
    }

    try {
      const selectedLead = projectLeads.find(lead => String(lead.id) === String(formData.project_lead));
      if (!selectedLead) {
        alert('Selected project lead not found');
        return;
      }

      const projectData = {
        name: formData.name,
        department: formData.department,
        manager: selectedLead.name,
        start_date: formData.start_date || null,
        end_date: formData.end_date || null,
        current_phase: formData.current_phase || 'Planning',
        status: formData.status,
        description: formData.description || ''
      };

      const response = await projectAPI.create(projectData);
      if (response.data.success) {
        setFormData({ name: '', department: '', project_lead: '', start_date: '', end_date: '', current_phase: '', status: 'On Track', description: '' });
        setIsModalOpen(false);
        await fetchAllData();
        alert('Project created successfully!');
      }
    } catch (err) {
      console.error('Error creating project:', err);
      alert(err.response?.data?.message || 'Failed to create project');
    }
  };

  const handleDeleteProject = async () => {
    if (!selectedProject) return;
    try {
      const response = await projectAPI.delete(selectedProject.id);
      if (response.data.success) {
        setIsDeleteModalOpen(false);
        setIsViewModalOpen(false);
        setSelectedProject(null);
        await fetchAllData();
        alert('Project deleted successfully!');
      }
    } catch (err) {
      console.error('Error deleting project:', err);
      alert('Failed to delete project');
    }
  };

  const handleExportProjects = () => {
    try {
      const userProjects = getUserProjects();
      const filteredProjects = userProjects.filter(project => {
        if (searchTerm && !project.name.toLowerCase().includes(searchTerm.toLowerCase())) return false;
        if (filters.status && project.status !== filters.status) return false;
        if (filters.department && project.department !== filters.department) return false;
        return true;
      });

      if (filteredProjects.length === 0) {
        alert('No projects to export!');
        return;
      }

      const exportData = filteredProjects.map(project => ({
        'Project Name': project.name,
        'Department': project.department,
        'Project Lead': project.manager,
        'Start Date': formatDate(project.start_date),
        'End Date': formatDate(project.end_date),
        'Current Phase': project.current_phase,
        'Progress': `${project.progress}%`,
        'Status': project.status
      }));

      const worksheet = XLSX.utils.json_to_sheet(exportData);
      const workbook = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(workbook, worksheet, 'Projects');
      XLSX.writeFile(workbook, `Projects_Export_${new Date().toISOString().split('T')[0]}.xlsx`);
      alert(`Exported ${filteredProjects.length} projects successfully!`);
    } catch (error) {
      console.error('Error exporting data:', error);
      alert('Error exporting data');
    }
  };

  const getStatusBadge = (project) => {
    const statusMap = {
      'On Track': 'proj-status-active',
      'Delayed': 'proj-status-inactive',
      'At Risk': 'proj-status-inactive',
      'Completed': 'proj-status-active',
      'On Hold': 'proj-status-inactive'
    };
    return (
      <span className={`proj-status-badge ${statusMap[project.status] || 'proj-status-inactive'}`}>
        {project.status?.toUpperCase() || 'UNKNOWN'}
      </span>
    );
  };

  const getTaskPriorityBadge = (priority) => {
    const priorityMap = { 'High': 'priority-high', 'Medium': 'priority-medium', 'Low': 'priority-low' };
    return <span className={`task-priority-badge ${priorityMap[priority]}`}>{priority}</span>;
  };

  const getTaskStatusIcon = (status) => {
    switch(status) {
      case 'Completed': return <FaCheckCircle style={{ color: '#28a745' }} />;
      case 'In Progress': return <FaHourglassHalf style={{ color: '#ffc107' }} />;
      case 'To-Do': return <FaClock style={{ color: '#6c757d' }} />;
      case 'Blocked': return <FaExclamationTriangle style={{ color: '#dc3545' }} />;
      default: return null;
    }
  };

  const formatDate = (dateString) => {
    if (!dateString) return 'Not set';
    return new Date(dateString).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
  };

  const handleFilterChange = (key, value) => {
    setFilters(prev => ({ ...prev, [key]: value }));
  };

  const calculateOverallProjectProgress = (projectId) => {
    const projectTasks = tasks.filter(task => task.project_id == projectId);
    if (projectTasks.length === 0) return 0;
    
    let totalProgress = 0;
    let completedTasks = 0;
    let inProgressTasks = 0;
    
    projectTasks.forEach(task => {
      totalProgress += task.progress || 0;
      if (task.status === 'Completed') completedTasks++;
      else if (task.status === 'In Progress') inProgressTasks++;
    });
    
    const averageProgress = totalProgress / projectTasks.length;
    const completionRate = (completedTasks / projectTasks.length) * 100;
    const inProgressRate = (inProgressTasks / projectTasks.length) * 50;
    let overallProgress = (averageProgress * 0.5) + (completionRate * 0.3) + (inProgressRate * 0.2);
    return Math.round(overallProgress);
  };

  const userProjects = getUserProjects();
  const userTasks = getUserTasks();

  const filteredProjects = userProjects.filter(project => {
    if (searchTerm && !project.name.toLowerCase().includes(searchTerm.toLowerCase())) return false;
    if (filters.status && project.status !== filters.status) return false;
    if (filters.department && project.department !== filters.department) return false;
    return true;
  });

  if (loading) {
    return (
      <div className="proj-management-section">
        <div className="proj-loading">Loading projects...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="proj-management-section">
        <div className="proj-error">{error}</div>
        <button onClick={fetchAllData} className="proj-retry-btn">Try Again</button>
      </div>
    );
  }

  return (
    <div className="proj-management-section" id="proj-management-main">
      {/* Header */}
      <div className="proj-management-header">
        <h2 id="proj-management-title">
          Project Management System
          {currentUser.role === 'hr' && <span className="proj-hr-badge">HR Access</span>}
          {currentUser.isProjectLead && <span className="proj-lead-badge">Project Lead</span>}
        </h2>
        <div className="proj-user-info">
          <span className="proj-user-name">{currentUser.name}</span>
          <span className="proj-user-role">
            {currentUser.role === 'hr' ? 'HR Administrator' : (currentUser.isProjectLead ? 'Project Lead' : 'Team Member')}
          </span>
        </div>
        <div className="proj-header-actions">
          <button className={`proj-tab-btn ${activeTab === 'projects' ? 'active' : ''}`} onClick={() => setActiveTab('projects')}>
            <FaTasks /> Projects ({userProjects.length})
          </button>
          {canViewTeamManagement() && (
            <button className={`proj-tab-btn ${activeTab === 'teams' ? 'active' : ''}`} onClick={() => setActiveTab('teams')}>
              <FaUsers /> Teams ({teams.filter(t => currentUser.managedProjects.includes(t.project_id)).length})
            </button>
          )}
          <button className={`proj-tab-btn ${activeTab === 'tasks' ? 'active' : ''}`} onClick={() => setActiveTab('tasks')}>
            <FaTasks /> Tasks ({userTasks.length})
          </button>
          {canCreateProject() && activeTab === 'projects' && (
            <button className="proj-add-btn" onClick={() => setIsModalOpen(true)}><FaPlus /> Create Project</button>
          )}
          {canCreateTeam() && activeTab === 'teams' && (
            <button className="proj-add-btn" onClick={() => setIsTeamModalOpen(true)}><FaUsers /> Create Team</button>
          )}
        </div>
      </div>

      {/* Dashboard Stats */}
      <div className="proj-dashboard-stats">
        <div className="proj-stat-card"><div className="proj-stat-number">{dashboardStats.totalProjects}</div><div className="proj-stat-label">Total Projects</div></div>
        <div className="proj-stat-card"><div className="proj-stat-number">{dashboardStats.activeProjects}</div><div className="proj-stat-label">Active Projects</div></div>
        <div className="proj-stat-card"><div className="proj-stat-number">{dashboardStats.delayedProjects}</div><div className="proj-stat-label">Delayed Projects</div></div>
        <div className="proj-stat-card"><div className="proj-stat-number">{teams.length}</div><div className="proj-stat-label">Teams</div></div>
        <div className="proj-stat-card"><div className="proj-stat-number">{userTasks.length}</div><div className="proj-stat-label">My Tasks</div></div>
      </div>

      {/* Projects Tab */}
      {activeTab === 'projects' && (
        <div className="proj-table-container">
          <div className="proj-table-header">
            <h3>Project Directory</h3>
            <div className="proj-table-actions">
              <input type="text" placeholder="Search projects..." className="proj-filter-input" value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
              <select className="proj-filter-select" value={filters.status} onChange={(e) => handleFilterChange('status', e.target.value)}>
                <option value="">All Status</option>
                {projectStatuses.map(status => <option key={status} value={status}>{status}</option>)}
              </select>
              <select className="proj-filter-select" value={filters.department} onChange={(e) => handleFilterChange('department', e.target.value)}>
                <option value="">All Departments</option>
                {departments.map(dept => <option key={dept} value={dept}>{dept}</option>)}
              </select>
              <button className="proj-export-btn" onClick={handleExportProjects} disabled={filteredProjects.length === 0}>Export</button>
            </div>
          </div>
          <div className="proj-table-wrapper">
            <table className="proj-main-table">
              <thead>
                <tr>
                  <th>Project Name</th>
                  <th>Department</th>
                  <th>Project Lead</th>
                  <th>Start Date</th>
                  <th>End Date</th>
                  <th>Current Phase</th>
                  <th>Progress</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {filteredProjects.map(project => (
                  <tr key={project.id}>
                    <td>{project.name}</td>
                    <td>{project.department}</td>
                    <td>{project.manager}</td>
                    <td>{formatDate(project.start_date)}</td>
                    <td>{formatDate(project.end_date)}</td>
                    <td>{project.current_phase}</td>
                    <td>{project.progress}%</td>
                    <td>{getStatusBadge(project)}</td>
                    <td style={{ minWidth: '120px' }}>
                      <button onClick={() => { setSelectedProject(project); setIsViewModalOpen(true); }} className="proj-action-btn" title="View Details">
                        <FaEye />
                      </button>
                      {canEditProject() && (
                        <button onClick={() => { setSelectedProject(project); setIsDeleteModalOpen(true); }} className="proj-action-btn" title="Delete Project" style={{ color: '#dc3545' }}>
                          <FaTrash />
                        </button>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Teams Tab */}
      {activeTab === 'teams' && canViewTeamManagement() && (
        <div className="proj-table-container">
          <div className="proj-table-header">
            <h3>Teams ({teams.filter(t => currentUser.managedProjects.includes(t.project_id)).length})</h3>
            <div className="proj-table-actions">
              {canCreateTeam() && <button className="proj-add-btn" onClick={() => setIsTeamModalOpen(true)}><FaUsers /> Create Team</button>}
            </div>
          </div>
          <div className="proj-table-wrapper">
            {teams.filter(t => currentUser.managedProjects.includes(t.project_id)).length === 0 ? (
              <div className="proj-empty-state">
                <div className="proj-empty-icon">👥</div>
                <p>No teams found. Create a team to get started!</p>
              </div>
            ) : (
              <table className="proj-main-table">
                <thead>
                  <tr>
                    <th>Team Name</th>
                    <th>Project</th>
                    <th>Team Lead</th>
                    <th>Members</th>
                    <th>Member Count</th>
                    <th>Status</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {teams.filter(team => currentUser.managedProjects.includes(team.project_id)).map(team => {
                    const project = projects.find(p => p.id === team.project_id);
                    const membersList = team.members || [];
                    return (
                      <tr key={team.id}>
                        <td><strong>{team.name}</strong></td>
                        <td>{project ? <span className="project-badge">{project.name}</span> : <span className="text-muted">Not Assigned</span>}</td>
                        <td>{team.team_lead_name || 'Not Assigned'}</td>
                        <td>
                          <div className="team-members-list">
                            {membersList && membersList.length > 0 ? (
                              membersList.map((member, index) => (
                                <div key={member.id || index} className="member-item">
                                  <span className="member-name">{member.name || 'Unknown'}</span>
                                  <small className="member-position">{member.position || 'Member'}</small>
                                </div>
                              ))
                            ) : (
                              <span className="text-muted">No members assigned</span>
                            )}
                          </div>
                        </td>
                        <td>{membersList.length || team.member_count || 0}</td>
                        <td>
                          <span className={`team-status-badge ${team.status === 'Active' ? 'status-active' : 'status-inactive'}`}>
                            {team.status || 'Active'}
                          </span>
                        </td>
                        <td style={{ minWidth: '120px' }}>
                          <button 
                            onClick={() => {
                              const membersListText = membersList && membersList.length > 0
                                ? membersList.map(m => `- ${m.name} (${m.position || 'Member'})`).join('\n')
                                : 'No members assigned';
                              alert(`Team: ${team.name}\nProject: ${project?.name || 'Not Assigned'}\nLead: ${team.team_lead_name || 'None'}\n\nMembers (${membersList.length}):\n${membersListText}`);
                            }} 
                            className="proj-action-btn" 
                            title="View Team Details"
                          >
                            <FaEye />
                          </button>
                          {canDeleteTeam(team) && (
                            <button 
                              onClick={() => { setSelectedTeam(team); setIsDeleteTeamModalOpen(true); }} 
                              className="proj-action-btn" 
                              title="Delete Team" 
                              style={{ color: '#dc3545' }}
                            >
                              <FaTrash />
                            </button>
                          )}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            )}
          </div>
        </div>
      )}

      {/* Tasks Tab */}
      {activeTab === 'tasks' && (
        <div className="proj-table-container">
          <div className="proj-table-header">
            <h3>Tasks</h3>
            <div className="proj-table-actions">
              <select 
                className="proj-filter-select" 
                value={selectedProject?.id || ''} 
                onChange={(e) => {
                  const projectId = e.target.value;
                  if (projectId) {
                    const project = projects.find(p => p.id == projectId);
                    setSelectedProject(project);
                  } else {
                    setSelectedProject(null);
                  }
                }}
                style={{ minWidth: '250px', padding: '8px', borderRadius: '4px', border: '1px solid #ddd' }}
              >
                <option value="">-- Select a Project --</option>
                {userProjects.map(p => (
                  <option key={p.id} value={p.id}>{p.name}</option>
                ))}
              </select>
              
              <button 
                className={`proj-filter-btn ${showMonthFilter ? 'active' : ''}`}
                onClick={() => setShowMonthFilter(!showMonthFilter)}
                style={{
                  padding: '8px 12px',
                  background: showMonthFilter ? '#4caf50' : '#6c757d',
                  color: 'white',
                  border: 'none',
                  borderRadius: '4px',
                  cursor: 'pointer'
                }}
              >
                📅 {showMonthFilter ? 'Filter ON' : 'Filter OFF'}
              </button>
              
              {showMonthFilter && (
                <>
                  <select 
                    value={selectedMonth}
                    onChange={(e) => setSelectedMonth(parseInt(e.target.value))}
                    className="proj-filter-select"
                    style={{ padding: '8px', borderRadius: '4px' }}
                  >
                    {Array.from({ length: 12 }, (_, i) => (
                      <option key={i} value={i}>{getMonthName(i)}</option>
                    ))}
                  </select>
                  
                  <select 
                    value={selectedYear}
                    onChange={(e) => setSelectedYear(parseInt(e.target.value))}
                    className="proj-filter-select"
                    style={{ padding: '8px', borderRadius: '4px' }}
                  >
                    {Array.from({ length: 5 }, (_, i) => {
                      const year = new Date().getFullYear() - 2 + i;
                      return <option key={year} value={year}>{year}</option>;
                    })}
                  </select>
                </>
              )}
              
              {canCreateTask(selectedProject?.id) && (
                <button className="proj-add-btn" onClick={() => setIsTaskModalOpen(true)}><FaPlus /> Create Task</button>
              )}
            </div>
          </div>
          
          {selectedProject && (
            <div style={{ 
              padding: '15px 20px', 
              background: 'linear-gradient(135deg, #667eea15 0%, #764ba215 100%)',
              borderBottom: '1px solid #e9ecef',
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center',
              flexWrap: 'wrap',
              gap: '10px'
            }}>
              <div>
                <strong style={{ fontSize: '14px', color: '#2c3e50' }}>📊 Overall Project Progress:</strong>
                <div style={{ marginTop: '5px' }}>
                  <div style={{ width: '300px', height: '8px', background: '#e9ecef', borderRadius: '4px', overflow: 'hidden' }}>
                    <div style={{ width: `${calculateOverallProjectProgress(selectedProject.id)}%`, height: '100%', background: 'linear-gradient(135deg, #667eea, #764ba2)', borderRadius: '4px' }} />
                  </div>
                </div>
              </div>
              <div style={{ fontSize: '13px', color: '#666' }}>
                Total Tasks: {tasks.filter(t => t.project_id == selectedProject.id).length} | 
                Completed: {tasks.filter(t => t.project_id == selectedProject.id && t.status === 'Completed').length} |
                In Progress: {tasks.filter(t => t.project_id == selectedProject.id && t.status === 'In Progress').length}
                {showMonthFilter && (
                  <span style={{ marginLeft: '10px', padding: '4px 8px', background: '#e3f2fd', borderRadius: '4px' }}>
                    Filtered: {getMonthName(selectedMonth)} {selectedYear}
                  </span>
                )}
              </div>
            </div>
          )}
          
          <div className="proj-table-wrapper">
            {!selectedProject ? (
              <div className="proj-empty-state">
                <div className="proj-empty-icon">📋</div>
                <p>Please select a project from the dropdown above to view its tasks.</p>
              </div>
            ) : (() => {
              let projectTasks = tasks.filter(task => task.project_id == selectedProject.id);
              
              if (showMonthFilter) {
                projectTasks = filterTasksByMonth(projectTasks, selectedMonth, selectedYear);
              }
              
              if (projectTasks.length === 0) {
                return (
                  <div className="proj-empty-state">
                    <div className="proj-empty-icon">📋</div>
                    <p>No tasks found for project: <strong>{selectedProject.name}</strong></p>
                    {showMonthFilter && (
                      <p style={{ fontSize: '13px', color: '#666' }}>
                        Filter applied: {getMonthName(selectedMonth)} {selectedYear}
                      </p>
                    )}
                    {canCreateTask(selectedProject?.id) && (
                      <button className="proj-add-btn" onClick={() => setIsTaskModalOpen(true)} style={{ marginTop: '15px' }}>
                        <FaPlus /> Create First Task
                      </button>
                    )}
                  </div>
                );
              }
              
              return (
                <>
                  <div style={{ padding: '10px', background: '#f8f9fa', borderBottom: '1px solid #dee2e6', display: 'flex', gap: '10px', justifyContent: 'flex-end' }}>
                    <button onClick={() => openExcelEditor()} className="proj-action-btn" style={{ background: '#4caf50', color: 'white', padding: '8px 16px', borderRadius: '4px', border: 'none', cursor: 'pointer' }}>
                      <FaFileExcel /> Edit in Sheet View
                    </button>
                  </div>
                  
                  <table className="proj-main-table">
                    <thead>
                      <tr>
                        <th>Date</th>
                        <th>Project</th>
                        <th>Task/Activity</th>
                        <th>Description (What I did)</th>
                        <th>Status</th>
                        <th>Remarks</th>
                        <th>Actions</th>
                      </tr>
                    </thead>
                    <tbody>
                      {projectTasks.map(task => (
                        <tr key={task.id}>
                          <td style={{ whiteSpace: 'nowrap' }}>{task.created_at ? formatDate(task.created_at) : formatDate(new Date())}</td>
                          <td>{selectedProject?.name}</td>
                          <td>
                            <strong>{task.title}</strong>
                            <div style={{ fontSize: '11px', color: '#666', marginTop: '4px' }}>
                              Priority: {getTaskPriorityBadge(task.priority)}
                            </div>
                            {task.due_date && (
                              <div style={{ fontSize: '11px', color: '#666' }}>Due: {formatDate(task.due_date)}</div>
                            )}
                          </td>
                          <td style={{ minWidth: '250px' }}>{task.description || <span style={{ color: '#999', fontStyle: 'italic' }}>No description added yet</span>}</td>
                          <td style={{ minWidth: '150px' }}>
                            <div className="task-status-text">
                              {getTaskStatusIcon(task.status)}
                              {task.status}
                            </div>
                          </td>
                          <td style={{ minWidth: '200px' }}>{task.remarks || <span style={{ color: '#999', fontStyle: 'italic' }}>No remarks</span>}</td>
                          <td style={{ minWidth: '150px' }}>
                            <button onClick={() => { setSelectedTask(task); setIsTaskDetailsModalOpen(true); }} className="proj-action-btn" title="View Details">
                              <FaEye />
                            </button>
                            <button onClick={() => openEditTaskModal(task)} className="proj-action-btn" title="Edit Task" style={{ color: '#ffc107' }}>
                              <FaEdit />
                            </button>
                            {canDeleteTask(task) && (
                              <button onClick={() => { setSelectedTask(task); setIsDeleteTaskModalOpen(true); }} className="proj-action-btn" title="Delete Task" style={{ color: '#dc3545' }}>
                                <FaTrash />
                              </button>
                            )}
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </>
              );
            })()}
          </div>
        </div>
      )}

      {/* Delete Task Confirmation Modal */}
      {isDeleteTaskModalOpen && selectedTask && (
        <div className="proj-modal-overlay">
          <div className="proj-modal-content">
            <div className="proj-modal-header">
              <h2>Delete Task</h2>
              <button className="proj-close-btn" onClick={() => setIsDeleteTaskModalOpen(false)}>×</button>
            </div>
            <div className="proj-delete-confirm">
              <div className="emp-delete-icon"><FaExclamationTriangle /></div>
              <h3>Delete "{selectedTask.title}"?</h3>
              <p>Are you sure you want to delete this task? This action cannot be undone.</p>
              <div className="proj-delete-actions">
                <button onClick={() => setIsDeleteTaskModalOpen(false)} className="proj-cancel-btn">Cancel</button>
                <button onClick={handleDeleteTask} className="proj-delete-btn">Delete Task</button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Delete Team Confirmation Modal */}
      {isDeleteTeamModalOpen && selectedTeam && (
        <div className="proj-modal-overlay">
          <div className="proj-modal-content">
            <div className="proj-modal-header">
              <h2>Delete Team</h2>
              <button className="proj-close-btn" onClick={() => setIsDeleteTeamModalOpen(false)}>×</button>
            </div>
            <div className="proj-delete-confirm">
              <div className="emp-delete-icon"><FaExclamationTriangle /></div>
              <h3>Delete Team "{selectedTeam.name}"?</h3>
              <p>Are you sure you want to delete this team? This action cannot be undone.</p>
              <div className="proj-delete-actions">
                <button onClick={() => setIsDeleteTeamModalOpen(false)} className="proj-cancel-btn">Cancel</button>
                <button onClick={handleDeleteTeam} className="proj-delete-btn">Delete Team</button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Edit Task Modal */}
      {isEditTaskModalOpen && selectedTask && (
        <div className="proj-modal-overlay">
          <div className="proj-modal-content proj-large-modal">
            <div className="proj-modal-header">
              <h2>Edit Task - {selectedTask.title}</h2>
              <button className="proj-close-btn" onClick={() => setIsEditTaskModalOpen(false)}>×</button>
            </div>
            <form onSubmit={handleEditTaskSubmit} className="proj-form">
              <div className="proj-form-group">
                <label>Task Title</label>
                <input 
                  type="text" 
                  value={editTaskData.title} 
                  onChange={(e) => setEditTaskData({...editTaskData, title: e.target.value})}
                  disabled={!canEditTask(selectedTask)}
                  style={!canEditTask(selectedTask) ? { background: '#f5f5f5' } : {}}
                />
              </div>
              
              <div className="proj-form-group">
                <label>Description</label>
                <textarea 
                  value={editTaskData.description} 
                  onChange={(e) => setEditTaskData({...editTaskData, description: e.target.value})}
                  rows="4"
                  placeholder="Describe what you did..."
                />
                <small style={{ color: '#666', fontSize: '11px' }}>
                  {canEditTask(selectedTask) ? 'You can edit this field' : 'Only assigned employee or project lead can edit'}
                </small>
              </div>
              
              <div className="proj-form-row">
                <div className="proj-form-group">
                  <label>Status</label>
                  <select 
                    value={editTaskData.status} 
                    onChange={(e) => setEditTaskData({...editTaskData, status: e.target.value})}
                    disabled={!canEditTask(selectedTask)}
                    style={!canEditTask(selectedTask) ? { background: '#f5f5f5' } : {}}
                  >
                    {taskStatuses.map(s => <option key={s} value={s}>{s}</option>)}
                  </select>
                </div>
                <div className="proj-form-group">
                  <label>Priority</label>
                  <select 
                    value={editTaskData.priority} 
                    onChange={(e) => setEditTaskData({...editTaskData, priority: e.target.value})}
                    disabled={!canEditTask(selectedTask)}
                    style={!canEditTask(selectedTask) ? { background: '#f5f5f5' } : {}}
                  >
                    {taskPriorities.map(p => <option key={p} value={p}>{p}</option>)}
                  </select>
                </div>
              </div>
              
              <div className="proj-form-group">
                <label>Remarks</label>
                <textarea 
                  value={editTaskData.remarks} 
                  onChange={(e) => setEditTaskData({...editTaskData, remarks: e.target.value})}
                  rows="2"
                  placeholder="Add any remarks..."
                />
              </div>
              
              <div className="proj-form-group">
                <label>Due Date</label>
                <input 
                  type="date" 
                  value={editTaskData.due_date ? editTaskData.due_date.split('T')[0] : ''} 
                  onChange={(e) => setEditTaskData({...editTaskData, due_date: e.target.value})}
                />
              </div>
              
              <div className="proj-form-actions">
                <button type="button" onClick={() => setIsEditTaskModalOpen(false)} className="proj-cancel-btn">Cancel</button>
                <button type="submit" className="proj-submit-btn">Save Changes</button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Rest of the modals (Create Team, Create Task, Create Project, etc.) remain the same */}
      {/* Create Team Modal */}
      {isTeamModalOpen && canCreateTeam() && (
        <div className="proj-modal-overlay">
          <div className="proj-modal-content proj-large-modal">
            <div className="proj-modal-header">
              <h2>Create New Team</h2>
              <button className="proj-close-btn" onClick={() => setIsTeamModalOpen(false)}>×</button>
            </div>
            <form onSubmit={handleCreateTeam} className="proj-form">
              <div className="proj-form-group">
                <label className="required">Project *</label>
                <select 
                  name="project_id" 
                  value={teamFormData.project_id} 
                  onChange={(e) => setTeamFormData({...teamFormData, project_id: e.target.value})} 
                  required
                >
                  <option value="">Select Project</option>
                  {projects.filter(p => currentUser.managedProjects.includes(p.id)).map(project => (
                    <option key={project.id} value={project.id}>{project.name}</option>
                  ))}
                </select>
              </div>
              <div className="proj-form-group">
                <label className="required">Team Name *</label>
                <input 
                  type="text" 
                  name="name" 
                  value={teamFormData.name} 
                  onChange={(e) => setTeamFormData({...teamFormData, name: e.target.value})} 
                  required 
                  placeholder="e.g., Frontend Development Team" 
                />
              </div>
              <div className="proj-form-group">
                <label>Team Lead</label>
                <select 
                  name="team_lead_id" 
                  value={teamFormData.team_lead_id} 
                  onChange={(e) => setTeamFormData({...teamFormData, team_lead_id: e.target.value})}
                >
                  <option value="">Select Team Lead (Optional)</option>
                  {projectLeads.map(lead => <option key={lead.id} value={lead.id}>{lead.name} ({lead.position || 'Employee'})</option>)}
                </select>
              </div>
              
              <div className="proj-form-group">
                <label className="required">Team Members *</label>
                <div style={{ 
                  marginBottom: '10px', 
                  padding: '10px', 
                  background: '#f8f9fa', 
                  border: '1px solid #dee2e6', 
                  borderRadius: '4px',
                  minHeight: '60px'
                }}>
                  <strong>Selected Members ({selectedEmployees.length}):</strong>
                  {selectedEmployees.length > 0 ? (
                    <div style={{ display: 'flex', flexWrap: 'wrap', gap: '6px', marginTop: '8px' }}>
                      {selectedEmployees.map(id => {
                        const emp = employees.find(e => e.id == id);
                        return emp ? (
                          <span key={id} style={{
                            display: 'inline-flex', alignItems: 'center', gap: '4px',
                            background: '#28a745', color: 'white', padding: '4px 10px',
                            borderRadius: '16px', fontSize: '13px'
                          }}>
                            {emp.name}
                            <button 
                              type="button" 
                              onClick={() => handleEmployeeSelection(id)} 
                              style={{ 
                                background: 'none', border: 'none', color: 'white', 
                                cursor: 'pointer', fontSize: '16px', lineHeight: 1, padding: 0 
                              }}
                            >×</button>
                          </span>
                        ) : (
                          <span key={id} style={{
                            display: 'inline-flex', alignItems: 'center', gap: '4px',
                            background: '#dc3545', color: 'white', padding: '4px 10px',
                            borderRadius: '16px', fontSize: '13px'
                          }}>
                            ID: {id} (Not Found)
                            <button 
                              type="button" 
                              onClick={() => handleEmployeeSelection(id)} 
                              style={{ 
                                background: 'none', border: 'none', color: 'white', 
                                cursor: 'pointer', fontSize: '16px', lineHeight: 1, padding: 0 
                              }}
                            >×</button>
                          </span>
                        );
                      })}
                    </div>
                  ) : (
                    <div style={{ color: '#dc3545', marginTop: '6px', fontSize: '13px' }}>
                      ⚠️ No members selected. Please select at least one team member below.
                    </div>
                  )}
                </div>

                <div style={{ 
                  maxHeight: '240px', 
                  overflowY: 'auto', 
                  border: '1px solid #ced4da', 
                  borderRadius: '4px',
                  background: 'white'
                }}>
                  <div style={{ 
                    padding: '8px 12px', 
                    background: '#e9ecef', 
                    fontWeight: '600', 
                    fontSize: '13px',
                    position: 'sticky',
                    top: 0,
                    borderBottom: '1px solid #ced4da'
                  }}>
                    Available Employees ({employees.filter(emp => emp.role_name?.toLowerCase() !== 'hr').length})
                  </div>
                  {employees.length === 0 ? (
                    <div style={{ padding: '20px', textAlign: 'center', color: '#6c757d' }}>
                      ⚠️ No employees found. Please check if employees are loaded.
                    </div>
                  ) : (
                    employees
                      .filter(emp => emp.role_name?.toLowerCase() !== 'hr')
                      .map(emp => {
                        const empId = String(emp.id);
                        const isSelected = selectedEmployees.includes(empId);
                        return (
                          <label 
                            key={emp.id} 
                            style={{ 
                              display: 'flex', 
                              alignItems: 'center', 
                              padding: '10px 12px', 
                              cursor: 'pointer',
                              borderBottom: '1px solid #f0f0f0',
                              background: isSelected ? '#e3f2fd' : 'white'
                            }}
                          >
                            <input 
                              type="checkbox" 
                              checked={isSelected}
                              onChange={() => handleEmployeeSelection(empId)} 
                              style={{ marginRight: '12px', width: '16px', height: '16px', cursor: 'pointer' }}
                            />
                            <span style={{ flex: 1, fontWeight: isSelected ? '600' : '400' }}>
                              {emp.name}
                            </span>
                            <small style={{ color: '#6c757d', fontSize: '12px', marginRight: '8px' }}>
                              {emp.position || 'Employee'}
                            </small>
                            <small style={{ color: '#adb5bd', fontSize: '10px' }}>
                              ID: {emp.id}
                            </small>
                          </label>
                        );
                      })
                  )}
                </div>
                
                <small style={{ color: '#dc3545', display: 'block', marginTop: '5px' }}>
                  * Required: Select at least one member for the team
                </small>
              </div>
              
              <div className="proj-form-group">
                <label>Description</label>
                <textarea 
                  name="description" 
                  value={teamFormData.description} 
                  onChange={(e) => setTeamFormData({...teamFormData, description: e.target.value})} 
                  rows="3" 
                  placeholder="Describe the team's purpose..." 
                />
              </div>
              
              <div className="proj-form-actions">
                <button type="button" onClick={() => setIsTeamModalOpen(false)} className="proj-cancel-btn">Cancel</button>
                <button 
                  type="submit" 
                  className="proj-submit-btn"
                  disabled={selectedEmployees.length === 0}
                  style={selectedEmployees.length === 0 ? { opacity: 0.5, cursor: 'not-allowed' } : {}}
                >
                  Create Team with {selectedEmployees.length} Member(s)
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Create Task Modal */}
      {isTaskModalOpen && canCreateTask(selectedProject?.id) && (
        <div className="proj-modal-overlay">
          <div className="proj-modal-content proj-large-modal">
            <div className="proj-modal-header">
              <h2>Create New Task for {selectedProject?.name}</h2>
              <button className="proj-close-btn" onClick={() => setIsTaskModalOpen(false)}>×</button>
            </div>
            
            <form onSubmit={handleCreateTask} className="proj-form">
              <div className="proj-form-group">
                <label className="required">Project *</label>
                <input 
                  type="text" 
                  value={selectedProject?.name || 'No project selected'} 
                  disabled 
                  style={{ background: '#f5f5f5' }}
                />
                <input 
                  type="hidden" 
                  name="project_id" 
                  value={selectedProject?.id || ''} 
                />
              </div>
              
              <div className="proj-form-group">
                <label className="required">Task Title *</label>
                <input 
                  type="text" 
                  name="title" 
                  value={taskFormData.title} 
                  onChange={(e) => setTaskFormData({...taskFormData, title: e.target.value})} 
                  required 
                />
              </div>
              
              <div className="proj-form-group">
                <label>Select Team</label>
                <select 
                  name="team_id" 
                  value={taskFormData.team_id} 
                  onChange={(e) => {
                    const teamId = e.target.value;
                    setTaskFormData({...taskFormData, team_id: teamId});
                    
                    if (teamId) {
                      loadTeamMembers(teamId);
                    } else {
                      setAvailableTeamMembers([]);
                      setSelectedTaskEmployees([]);
                    }
                  }}
                  className="proj-form-select"
                >
                  <option value="">Select Team (Optional)</option>
                  {teams
                    .filter(team => team.project_id === selectedProject?.id)
                    .map(team => (
                      <option key={team.id} value={team.id}>
                        {team.name} (Members: {team.members?.length || team.member_count || 0})
                      </option>
                    ))}
                </select>
                {teams.filter(team => team.project_id === selectedProject?.id).length === 0 && (
                  <small style={{ color: '#f44336', display: 'block', marginTop: '5px' }}>
                    No teams found for this project. Please create a team first in the Teams tab.
                  </small>
                )}
              </div>
              
              {taskFormData.team_id && (
                <div className="proj-form-group">
                  <label className="required">Assign to Team Members *</label>
                  
                  {loadingTeamMembers ? (
                    <div className="loading-members">Loading team members...</div>
                  ) : availableTeamMembers.length > 0 ? (
                    <div style={{ maxHeight: '200px', overflowY: 'auto', border: '1px solid #ddd', borderRadius: '4px' }}>
                      {availableTeamMembers.map(member => (
                        <label key={member.user_id} style={{ 
                          display: 'flex', 
                          alignItems: 'center', 
                          padding: '10px', 
                          cursor: 'pointer', 
                          borderBottom: '1px solid #f0f0f0',
                          background: selectedTaskEmployees.includes(member.user_id) ? '#e3f2fd' : 'white'
                        }}>
                          <input 
                            type="checkbox" 
                            checked={selectedTaskEmployees.includes(member.user_id)} 
                            onChange={() => {
                              const userId = member.user_id;
                              setSelectedTaskEmployees(prev => 
                                prev.includes(userId) 
                                  ? prev.filter(id => id !== userId) 
                                  : [...prev, userId]
                              );
                            }} 
                            style={{ marginRight: '10px' }}
                          />
                          <span style={{ flex: 1 }}>
                            <strong>{member.name}</strong>
                            <br/>
                            <small style={{ color: '#666' }}>{member.position || 'Team Member'}</small>
                          </span>
                          <small style={{ color: '#999', fontSize: '10px', marginLeft: '8px' }}>
                            ID: {member.user_id}
                          </small>
                        </label>
                      ))}
                    </div>
                  ) : (
                    <div style={{ padding: '20px', textAlign: 'center', color: '#f44336', background: '#ffebee', borderRadius: '4px' }}>
                      ⚠️ No members found in this team.
                    </div>
                  )}
                </div>
              )}
              
              <div className="proj-form-row">
                <div className="proj-form-group">
                  <label>Priority</label>
                  <select name="priority" value={taskFormData.priority} onChange={(e) => setTaskFormData({...taskFormData, priority: e.target.value})}>
                    {taskPriorities.map(p => <option key={p} value={p}>{p}</option>)}
                  </select>
                </div>
                <div className="proj-form-group">
                  <label>Estimated Hours</label>
                  <input type="number" name="estimated_hours" value={taskFormData.estimated_hours} onChange={(e) => setTaskFormData({...taskFormData, estimated_hours: parseFloat(e.target.value)})} step="0.5" min="0" />
                </div>
              </div>
              
              <div className="proj-form-group">
                <label>Due Date</label>
                <input type="date" name="due_date" value={taskFormData.due_date} onChange={(e) => setTaskFormData({...taskFormData, due_date: e.target.value})} />
              </div>
              
              <div className="proj-form-group">
                <label>Description</label>
                <textarea name="description" value={taskFormData.description} onChange={(e) => setTaskFormData({...taskFormData, description: e.target.value})} rows="3" />
              </div>
              
              <div className="proj-form-actions">
                <button type="button" onClick={() => setIsTaskModalOpen(false)} className="proj-cancel-btn">Cancel</button>
                <button 
                  type="submit" 
                  className="proj-submit-btn"
                  disabled={!taskFormData.title || selectedTaskEmployees.length === 0}
                  style={(!taskFormData.title || selectedTaskEmployees.length === 0) ? { opacity: 0.5, cursor: 'not-allowed' } : {}}
                >
                  Create Task{selectedTaskEmployees.length > 0 ? ` for ${selectedTaskEmployees.length} Member(s)` : ''}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Create Project Modal */}
      {isModalOpen && canCreateProject() && (
        <div className="proj-modal-overlay">
          <div className="proj-modal-content proj-large-modal">
            <div className="proj-modal-header">
              <h2>Create New Project</h2>
              <button className="proj-close-btn" onClick={() => setIsModalOpen(false)}>×</button>
            </div>
            <form onSubmit={handleSubmitProject} className="proj-form">
              <div className="proj-form-section">
                <h3 className="proj-section-title"><FaBell /> Project Information</h3>
                <div className="proj-form-row">
                  <div className="proj-form-group">
                    <label className="required">Project Name *</label>
                    <input type="text" name="name" value={formData.name} onChange={(e) => setFormData({...formData, name: e.target.value})} required />
                  </div>
                  <div className="proj-form-group">
                    <label className="required">Department *</label>
                    <select name="department" value={formData.department} onChange={(e) => setFormData({...formData, department: e.target.value})} required>
                      <option value="">Select Department</option>
                      {departments.map(dept => <option key={dept} value={dept}>{dept}</option>)}
                    </select>
                  </div>
                </div>
                <div className="proj-form-row">
                  <div className="proj-form-group">
                    <label className="required">Project Lead *</label>
                    <select name="project_lead" value={formData.project_lead} onChange={(e) => setFormData({...formData, project_lead: e.target.value})} required>
                      <option value="">Select Project Lead</option>
                      {projectLeads.map(lead => <option key={lead.id} value={lead.id}>{lead.name} - {lead.position}</option>)}
                    </select>
                  </div>
                  <div className="proj-form-group">
                    <label>Status</label>
                    <select name="status" value={formData.status} onChange={(e) => setFormData({...formData, status: e.target.value})}>
                      {projectStatuses.map(status => <option key={status} value={status}>{status}</option>)}
                    </select>
                  </div>
                </div>
                <div className="proj-form-row">
                  <div className="proj-form-group">
                    <label>Start Date</label>
                    <input type="date" name="start_date" value={formData.start_date} onChange={(e) => setFormData({...formData, start_date: e.target.value})} />
                  </div>
                  <div className="proj-form-group">
                    <label>End Date</label>
                    <input type="date" name="end_date" value={formData.end_date} onChange={(e) => setFormData({...formData, end_date: e.target.value})} />
                  </div>
                </div>
                <div className="proj-form-group">
                  <label>Current Phase</label>
                  <select name="current_phase" value={formData.current_phase} onChange={(e) => setFormData({...formData, current_phase: e.target.value})}>
                    <option value="">Select Phase</option>
                    {phases.map(phase => <option key={phase} value={phase}>{phase}</option>)}
                  </select>
                </div>
                <div className="proj-form-group">
                  <label>Project Description</label>
                  <textarea name="description" value={formData.description} onChange={(e) => setFormData({...formData, description: e.target.value})} rows="3" />
                </div>
              </div>
              <div className="proj-form-actions">
                <button type="button" onClick={() => setIsModalOpen(false)} className="proj-cancel-btn">Cancel</button>
                <button type="submit" className="proj-submit-btn">Create Project</button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Task Details Modal */}
      {isTaskDetailsModalOpen && selectedTask && (
        <div className="proj-modal-overlay">
          <div className="proj-modal-content proj-large-modal">
            <div className="proj-modal-header">
              <h2>Task Details - {selectedTask.title}</h2>
              <button className="proj-close-btn" onClick={() => setIsTaskDetailsModalOpen(false)}>×</button>
            </div>
            <div className="proj-details-content">
              <div className="proj-details-grid">
                <div className="proj-detail-item"><label>Date</label><span>{new Date().toLocaleDateString()}</span></div>
                <div className="proj-detail-item"><label>Project</label><span>{selectedProject?.name}</span></div>
                <div className="proj-detail-item full-width"><label>Task/Activity</label><span>{selectedTask.title}</span></div>
                <div className="proj-detail-item full-width"><label>Description</label><span>{selectedTask.description || 'No description'}</span></div>
                <div className="proj-detail-item"><label>Status</label><span>{selectedTask.status}</span></div>
                <div className="proj-detail-item full-width"><label>Remarks</label><span>{selectedTask.remarks || 'No remarks'}</span></div>
                <div className="proj-detail-item"><label>Priority</label><span>{getTaskPriorityBadge(selectedTask.priority)}</span></div>
                <div className="proj-detail-item"><label>Due Date</label><span>{formatDate(selectedTask.due_date)}</span></div>
                <div className="proj-detail-item"><label>Assigned To</label><span>{selectedTask.assigned_to_name || 'Not Assigned'}</span></div>
                <div className="proj-detail-item"><label>Assigned By</label><span>{selectedTask.assigned_by_name}</span></div>
              </div>
              <div className="proj-form-actions">
                <button onClick={() => setIsTaskDetailsModalOpen(false)} className="proj-cancel-btn">Close</button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* View Project Details Modal */}
      {isViewModalOpen && selectedProject && (
        <div className="proj-modal-overlay">
          <div className="proj-modal-content proj-large-modal">
            <div className="proj-modal-header">
              <h2>Project Details - {selectedProject.name}</h2>
              <button className="proj-close-btn" onClick={() => setIsViewModalOpen(false)}>×</button>
            </div>
            <div className="proj-details-content">
              <div className="proj-details-grid">
                <div className="proj-detail-item"><label>Project ID</label><span>PROJ{String(selectedProject.id).padStart(3, '0')}</span></div>
                <div className="proj-detail-item"><label>Project Name</label><span>{selectedProject.name}</span></div>
                <div className="proj-detail-item"><label>Department</label><span>{selectedProject.department}</span></div>
                <div className="proj-detail-item"><label>Project Lead</label><span>{selectedProject.manager}</span></div>
                <div className="proj-detail-item"><label>Start Date</label><span>{formatDate(selectedProject.start_date)}</span></div>
                <div className="proj-detail-item"><label>End Date</label><span>{formatDate(selectedProject.end_date)}</span></div>
                <div className="proj-detail-item"><label>Current Phase</label><span>{selectedProject.current_phase}</span></div>
                <div className="proj-detail-item"><label>Progress</label><span>{selectedProject.progress}%</span></div>
                <div className="proj-detail-item"><label>Status</label><span>{getStatusBadge(selectedProject)}</span></div>
              </div>
              <div className="proj-form-actions">
                {canEditProject() && <button onClick={() => setIsDeleteModalOpen(true)} className="proj-delete-btn">Delete Project</button>}
                <button onClick={() => setIsViewModalOpen(false)} className="proj-cancel-btn">Close</button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Delete Project Confirmation Modal */}
      {isDeleteModalOpen && selectedProject && canEditProject() && (
        <div className="proj-modal-overlay">
          <div className="proj-modal-content">
            <div className="proj-modal-header">
              <h2>Delete Project</h2>
              <button className="proj-close-btn" onClick={() => setIsDeleteModalOpen(false)}>×</button>
            </div>
            <div className="proj-delete-confirm">
              <div className="emp-delete-icon"><FaExclamationTriangle /></div>
              <h3>Delete {selectedProject.name}?</h3>
              <p>Are you sure you want to delete this project? This action cannot be undone.</p>
              <div className="proj-delete-actions">
                <button onClick={() => setIsDeleteModalOpen(false)} className="proj-cancel-btn">Cancel</button>
                <button onClick={handleDeleteProject} className="proj-delete-btn">Delete Project</button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Excel-like Editor Modal */}
      {isExcelEditorOpen && (
        <div className="proj-modal-overlay">
          <div className="proj-modal-content" style={{ maxWidth: '95%', width: '1400px', maxHeight: '85vh' }}>
            <div className="proj-modal-header">
              <h2>📊 Edit Tasks - {selectedProject?.name}</h2>
              <button className="proj-close-btn" onClick={() => setIsExcelEditorOpen(false)}>×</button>
            </div>
            
            <div style={{ padding: '10px', background: '#f8f9fa', borderBottom: '1px solid #dee2e6', display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
              <button onClick={downloadSheetAsExcel} style={{ padding: '8px 16px', background: '#28a745', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>
                <FaDownload /> Download Excel
              </button>
            </div>
            
            <div style={{ padding: '20px', overflowX: 'auto', maxHeight: '55vh', overflowY: 'auto' }}>
              <table className="proj-main-table" style={{ minWidth: '1000px' }}>
                <thead>
                  <tr>
                    <th style={{ minWidth: '120px' }}>Date</th>
                    <th style={{ minWidth: '150px' }}>Project</th>
                    <th style={{ minWidth: '200px' }}>Task/Activity</th>
                    <th style={{ minWidth: '250px' }}>Description</th>
                    <th style={{ minWidth: '150px' }}>Status</th>
                    <th style={{ minWidth: '250px' }}>Remarks</th>
                    <th style={{ minWidth: '100px' }}>Priority</th>
                    <th style={{ minWidth: '120px' }}>Due Date</th>
                    <th style={{ minWidth: '150px' }}>Assigned To</th>
                  </tr>
                </thead>
                <tbody>
                  {editableTasks.map((task, index) => {
                    const isAssignedToMe = task.assignedTo === currentUser.name;
                    const isProjectLeadUser = currentUser.isProjectLead && currentUser.managedProjects.includes(selectedProject?.id);
                    
                    return (
                      <tr key={index} style={!task.id && !task.task ? { background: '#f9f9f9' } : {}}>
                        <td>{task.displayDate}</td>
                        <td>{task.project}</td>
                        <td>
                          {isProjectLeadUser ? (
                            <input
                              type="text"
                              value={task.task}
                              onChange={(e) => updateEditableTask(index, 'task', e.target.value)}
                              placeholder="Enter task name..."
                              style={{ width: '100%', padding: '5px', borderRadius: '4px', border: '1px solid #ddd' }}
                            />
                          ) : (
                            <strong>{task.task || <span style={{ color: '#999' }}>No task</span>}</strong>
                          )}
                          <div style={{ fontSize: '11px', color: '#666', marginTop: '4px' }}>
                            Priority: {getTaskPriorityBadge(task.priority)}
                          </div>
                        </td>
                        <td>
                          {isAssignedToMe || isProjectLeadUser ? (
                            <textarea
                              value={task.description}
                              onChange={(e) => updateEditableTask(index, 'description', e.target.value)}
                              rows="2"
                              style={{ width: '100%', padding: '5px', borderRadius: '4px', border: '1px solid #ddd' }}
                              placeholder="What did you do?"
                            />
                          ) : (
                            <div style={{ padding: '5px', background: '#f5f5f5', borderRadius: '4px', minHeight: '50px' }}>
                              {task.description || <span style={{ color: '#999' }}>No description</span>}
                            </div>
                          )}
                        </td>
                        <td>
                          {isProjectLeadUser ? (
                            <select
                              value={task.status}
                              onChange={(e) => updateEditableTask(index, 'status', e.target.value)}
                              style={{ width: '100%', padding: '5px', borderRadius: '4px', border: '1px solid #ddd' }}
                            >
                              {taskStatuses.map(s => (
                                <option key={s} value={s}>{s}</option>
                              ))}
                            </select>
                          ) : (
                            <div className="task-status-text">
                              {getTaskStatusIcon(task.status)}
                              {task.status}
                            </div>
                          )}
                        </td>
                        <td>
                          {isProjectLeadUser ? (
                            <textarea
                              value={task.remarks}
                              onChange={(e) => updateEditableTask(index, 'remarks', e.target.value)}
                              rows="2"
                              style={{ width: '100%', padding: '5px', borderRadius: '4px', border: '1px solid #ddd' }}
                              placeholder="Add remarks here..."
                            />
                          ) : (
                            <div style={{ padding: '5px', background: '#f5f5f5', borderRadius: '4px', minHeight: '50px' }}>
                              {task.remarks || <span style={{ color: '#999' }}>No remarks</span>}
                            </div>
                          )}
                        </td>
                        <td>{getTaskPriorityBadge(task.priority)}</td>
                        <td>{task.dueDate}</td>
                        <td>
                          {isProjectLeadUser ? (
                            <input
                              type="text"
                              value={task.assignedTo}
                              onChange={(e) => updateEditableTask(index, 'assignedTo', e.target.value)}
                              placeholder="Employee name"
                              style={{ width: '100%', padding: '5px', borderRadius: '4px', border: '1px solid #ddd' }}
                              list="employeeNames"
                            />
                          ) : (
                            task.assignedTo || 'Not Assigned'
                          )}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
            
            <div className="proj-form-actions" style={{ padding: '15px', borderTop: '1px solid #e9ecef' }}>
              <div style={{ fontSize: '13px', color: '#666', flex: 1 }}>
                <FaCheckCircle style={{ color: '#4caf50' }} /> Employees can edit Description | 
                <FaCheckCircle style={{ color: '#ff9800', marginLeft: '10px' }} /> Project Leads can edit Status & Remarks |
                <FaDownload style={{ color: '#2196f3', marginLeft: '10px' }} /> Download as Excel for offline editing
              </div>
              <button onClick={() => setIsExcelEditorOpen(false)} className="proj-cancel-btn">Cancel</button>
              <button onClick={saveExcelEdits} className="proj-submit-btn">Save All Changes</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ProjectManagement;