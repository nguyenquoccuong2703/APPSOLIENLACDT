import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, SafeAreaView, ScrollView, TouchableOpacity } from 'react-native';
import { useUser } from '../UserContext';

interface LeaveRequest {
    id: string;
    Userid: string;
    idstudent: string;
    idteacher: string;
    date: string;
    reason: string;
    status: string;
}

interface Student {
    StudentId: number;
    UserId: number;
    Name: string;
    ClassId: number;
}

interface TeacherClassAssignment {
    AssignmentId: number;
    TeacherId: number;
    ClassId: number;
    IsHeadTeacher: boolean;
}

interface Teacher {
    id: string;
    UserID: number;
}

interface Parent {
    UserID: number;
    ParentName: string;
}

const ApproveLeaveRequestScreen: React.FC = () => {
    const { user } = useUser();
    const [leaveRequests, setLeaveRequests] = useState<LeaveRequest[]>([]);
    const [students, setStudents] = useState<Student[]>([]);
    const [parents, setParents] = useState<Parent[]>([]);
    const [error, setError] = useState<string | null>(null);

    const fetchLeaveRequests = async () => {
        try {
            // Fetch the teacher's record using the user ID
            const teacherResponse = await fetch(`http://192.168.137.1:3000/Teacher?UserID=${user?.id}`);
            const teacherData: Teacher[] = await teacherResponse.json();
            const teacher = teacherData[0]; // Assuming one teacher per user

            // Fetch the class assignments of the teacher
            const assignmentsResponse = await fetch(`http://192.168.137.1:3000/TeacherClassAssignment?TeacherId=${teacher.id}`);
            const assignments: TeacherClassAssignment[] = await assignmentsResponse.json();

            // Get the class IDs where the teacher is the homeroom teacher
            const classIds = assignments.filter(a => a.IsHeadTeacher).map(a => a.ClassId);
            console.log("Filtered Class IDs:", classIds);

            // Fetch all students
            const studentsResponse = await fetch(`http://192.168.137.1:3000/Student`);
            const allStudents: Student[] = await studentsResponse.json();
            setStudents(allStudents);

            // Get user IDs of students in the classes where the teacher is homeroom teacher
            const studentUserIds = allStudents.filter(student => classIds.includes(student.ClassId)).map(student => student.UserId);
            console.log("Student User IDs:", studentUserIds);

            // Fetch all leave requests
            const leaveRequestsResponse = await fetch(`http://192.168.137.1:3000/LeaveRequests`);
            const allLeaveRequests: LeaveRequest[] = await leaveRequestsResponse.json();

            // Log Userid types in leave requests
            allLeaveRequests.forEach(request => {
                console.log("Leave Request Userid Type:", typeof request.Userid);
            });

            // Convert Userid to number for comparison
            const filteredLeaveRequests = allLeaveRequests.filter(request => studentUserIds.includes(Number(request.Userid)));
            console.log("Filtered Leave Requests:", filteredLeaveRequests);

            setLeaveRequests(filteredLeaveRequests);
        } catch (error) {
            console.error('Lỗi khi lấy thông tin xin nghỉ phép:', error);
            setError('Lỗi khi lấy thông tin xin nghỉ phép.');
        }
    };

    const fetchParents = async () => {
        try {
            const response = await fetch('http://192.168.137.1:3000/Parent');
            const data: Parent[] = await response.json();
            setParents(data);
        } catch (error) {
            console.error('Lỗi khi lấy thông tin phụ huynh:', error);
        }
    };

    const handleApproveLeaveRequest = async (request: LeaveRequest) => {
        if (user?.UserType === '2') {
            try {
                const response = await fetch(`http://192.168.137.1:3000/LeaveRequests/${request.id}`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        id: request.id,
                        Userid: request.Userid,
                        idstudent: request.idstudent,
                        idteacher: request.idteacher,
                        date: request.date,
                        reason: request.reason,
                        status: 'approved'
                    }),
                });

                if (response.ok) {
                    // Fetch updated leave requests
                    fetchLeaveRequests();
                    setError(null);

                    // Add a new record to the Attendance table
                    const attendanceResponse = await fetch(`http://192.168.137.1:3000/Attendance`, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({
                            student_id: Number(request.idstudent),
                            date: request.date,
                            status: 'excused', // or any appropriate status
                            notes: request.reason
                        }),
                    });

                    if (!attendanceResponse.ok) {
                        setError('Lỗi khi thêm bản ghi vào bảng Attendance.');
                    }
                } else {
                    setError('Lỗi khi xác nhận nghỉ phép.');
                }
            } catch (error) {
                console.error('Lỗi khi xác nhận nghỉ phép:', error);
                setError('Lỗi khi xác nhận nghỉ phép.');
            }
        } else {
            setError('Chỉ có giáo viên mới có thể xác nhận yêu cầu nghỉ phép.');
        }
    };

    useEffect(() => {
        fetchLeaveRequests();
        fetchParents();
    }, []);

    const getStudentNameById = (studentId: string) => {
        const student = students.find(s => s.StudentId.toString() === studentId);
        return student ? student.Name : 'Unknown';
    };

    const getParentNameByUserId = (userId: string) => {
        const parent = parents.find(p => p.UserID.toString() === userId);
        return parent ? parent.ParentName : 'Unknown';
    };

    return (
        <SafeAreaView style={styles.container}>
            <ScrollView contentContainerStyle={styles.scrollViewContainer}>
                <View style={styles.card}>
                    <Text style={styles.sectionText}>Yêu Cầu Nghỉ Phép</Text>
                    {leaveRequests.map((request, index) => (
                        <View key={index} style={styles.requestItem}>
                            {request.idstudent && (
                                <>
                                    <Text style={styles.requestText}>Tên học sinh: {getStudentNameById(request.idstudent)}</Text>
                                    <Text style={styles.requestText}>Tên phụ huynh: {getParentNameByUserId(request.Userid)}</Text>
                                </>
                            )}
                            <Text style={styles.requestText}>Ngày: {request.date}</Text>
                            <Text style={styles.requestText}>Lý do: {request.reason}</Text>
                            <Text style={styles.requestText}>Trạng thái: {request.status}</Text>
                            {user?.UserType === '2' && request.status === 'pending' && (
                                <TouchableOpacity style={styles.button} onPress={() => handleApproveLeaveRequest(request)}>
                                    <Text style={styles.buttonText}>Xác nhận</Text>
                                </TouchableOpacity>
                            )}
                        </View>
                    ))}
                </View>
            </ScrollView>
        </SafeAreaView>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#f0f0f0',
    },
    scrollViewContainer: {
        flexGrow: 1,
        paddingBottom: 20,
    },
    card: {
        width: '90%',
        backgroundColor: '#fff',
        padding: 20,
        marginVertical: 10,
        borderRadius: 15,
        shadowColor: '#000',
        shadowOffset: {
            width: 0,
            height: 2,
        },
        shadowOpacity: 0.25,
        shadowRadius: 3.84,
        elevation: 5,
        alignSelf: 'center',
        alignItems: 'center',
    },
    sectionText: {
        fontSize: 20,
        color: '#333',
        marginBottom: 10,
        fontWeight: 'bold',
        textAlign: 'center',
    },
    requestItem: {
        marginBottom: 10,
        padding: 10,
        backgroundColor: '#fff',
        borderRadius: 10,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 1 },
        shadowOpacity: 0.1,
        shadowRadius: 3,
        elevation: 2,
        width: '100%',
    },
    requestText: {
        fontSize: 16,
        color: '#555',
    },
    button: {
        backgroundColor: '#2196F3',
        borderRadius: 20,
        padding: 10,
        elevation: 2,
        alignItems: 'center',
        marginTop: 20,
        width: '80%',
    },
    buttonText: {
        color: 'white',
        fontWeight: 'bold',
    },
});

export default ApproveLeaveRequestScreen;
