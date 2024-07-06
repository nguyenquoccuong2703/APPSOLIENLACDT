import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, SafeAreaView, ScrollView, Modal, TouchableOpacity, TextInput } from 'react-native';
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
}

interface Parent {
    id: number;
    UserID: number;
    ParentName: string;
    ParentEmail: string;
}

const LeaveRequests: React.FC = () => {
    const { user, selectedStudent } = useUser();
    const [leaveRequests, setLeaveRequests] = useState<LeaveRequest[]>([]);
    const [students, setStudents] = useState<Student[]>([]);
    const [parents, setParents] = useState<Parent[]>([]);
    const [modalVisible, setModalVisible] = useState(false);
    const [leaveDate, setLeaveDate] = useState('');
    const [reason, setReason] = useState('');
    const [error, setError] = useState<string | null>(null);

    const fetchLeaveRequests = async () => {
        if (selectedStudent) {
            try {
                const response = await fetch(`http://192.168.137.1:3000/LeaveRequests?Userid=${selectedStudent.UserId}`);
                const data: LeaveRequest[] = await response.json();
                setLeaveRequests(data);
            } catch (error) {
                console.error('Lỗi khi lấy thông tin xin nghỉ phép:', error);
                setError('Lỗi khi lấy thông tin xin nghỉ phép.');
            }
        }
    };

    const fetchStudents = async () => {
        try {
            const response = await fetch('http://192.168.137.1:3000/Student');
            const data: Student[] = await response.json();
            setStudents(data);
        } catch (error) {
            console.error('Lỗi khi lấy thông tin học sinh:', error);
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

    const submitLeaveRequest = async () => {
        if (!leaveDate || !reason) {
            setError('Vui lòng điền đầy đủ thông tin.');
            return;
        }

        const currentTime = new Date();
        const currentHours = currentTime.getHours();

        if (user?.UserType === '1' && currentHours >= 7) {
            setError('Chỉ có thể gửi yêu cầu nghỉ phép trước 7h sáng.');
            return;
        }

        const idstudent = user?.UserType === '1' ? selectedStudent?.StudentId?.toString() ?? "" : "";
        const idteacher = user?.UserType !== '1' ? selectedStudent?.UserId?.toString() ?? "" : "";

        try {
            const response = await fetch('http://192.168.137.1:3000/LeaveRequests', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    Userid: user?.id.toString(),
                    idstudent: idstudent,
                    idteacher: idteacher,
                    date: leaveDate,
                    reason: reason,
                    status: 'pending'
                }),
            });

            if (response.ok) {
                fetchLeaveRequests();
                setModalVisible(false);
                setLeaveDate('');
                setReason('');
                setError(null);
            } else {
                setError('Lỗi khi gửi yêu cầu nghỉ phép.');
            }
        } catch (error) {
            console.error('Lỗi khi gửi yêu cầu nghỉ phép:', error);
            setError('Lỗi khi gửi yêu cầu nghỉ phép.');
        }
    };

    useEffect(() => {
        fetchStudents();
        fetchParents();
    }, []);

    useEffect(() => {
        fetchLeaveRequests();
    }, [selectedStudent]);

    const getStudentNameById = (studentId: number) => {
        const student = students.find(s => s.StudentId === studentId);
        return student ? student.Name : 'Unknown';
    };

    const getParentNameByUserId = (userId: number) => {
        const parent = parents.find(p => p.UserID === userId);
        return parent ? parent.ParentName : 'Unknown';
    };

    return (
        <SafeAreaView style={styles.container}>
            <ScrollView contentContainerStyle={styles.scrollViewContainer}>
                <View style={styles.card}>
                    <Text style={styles.sectionText}>Yêu Cầu Nghỉ Phép</Text>
                    {leaveRequests.map((request, index) => (
                        <View key={index} style={styles.requestItem}>
                            <Text style={styles.requestText}>Tên học sinh: {getStudentNameById(Number(request.idstudent))}</Text>
                            <Text style={styles.requestText}>Tên phụ huynh: {getParentNameByUserId(Number(request.Userid))}</Text>
                            <Text style={styles.requestText}>Ngày: {request.date}</Text>
                            <Text style={styles.requestText}>Lý do: {request.reason}</Text>
                            <Text style={styles.requestText}>Trạng thái: {request.status}</Text>
                        </View>
                    ))}
                    <TouchableOpacity style={styles.button} onPress={() => setModalVisible(true)}>
                        <Text style={styles.buttonText}>Gửi Yêu Cầu Nghỉ Phép</Text>
                    </TouchableOpacity>
                </View>
                <Modal
                    animationType="slide"
                    transparent={true}
                    visible={modalVisible}
                    onRequestClose={() => setModalVisible(!modalVisible)}
                >
                    <View style={styles.modalContainer}>
                        <View style={styles.modalView}>
                            <Text style={styles.modalText}>Gửi Yêu Cầu Nghỉ Phép</Text>
                            <TextInput
                                style={styles.input}
                                placeholder="Ngày (YYYY-MM-DD)"
                                value={leaveDate}
                                onChangeText={setLeaveDate}
                            />
                            <TextInput
                                style={styles.input}
                                placeholder="Lý do"
                                value={reason}
                                onChangeText={setReason}
                            />
                            {error && <Text style={styles.errorText}>{error}</Text>}
                            <TouchableOpacity style={[styles.button, styles.buttonClose]} onPress={submitLeaveRequest}>
                                <Text style={styles.textStyle}>Gửi</Text>
                            </TouchableOpacity>
                            <TouchableOpacity style={[styles.button, styles.buttonCancel]} onPress={() => setModalVisible(!modalVisible)}>
                                <Text style={styles.textStyle}>Hủy</Text>
                            </TouchableOpacity>
                        </View>
                    </View>
                </Modal>
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
    },
    sectionText: {
        fontSize: 20,
        color: '#333',
        marginBottom: 10,
        fontWeight: 'bold',
        textAlign: 'center',
    },
    errorText: {
        fontSize: 16,
        color: 'red',
        textAlign: 'center',
        marginTop: 10,
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
    },
    buttonText: {
        color: 'white',
        fontWeight: 'bold',
    },
    modalContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: 22,
    },
    modalView: {
        margin: 20,
        backgroundColor: 'white',
        borderRadius: 20,
        padding: 35,
        alignItems: 'center',
        shadowColor: '#000',
        shadowOffset: {
            width: 0,
            height: 2,
        },
        shadowOpacity: 0.25,
        shadowRadius: 4,
        elevation: 5,
        width: '90%',
    },
    input: {
        width: '100%',
        padding: 10,
        borderColor: '#ccc',
        borderWidth: 1,
        borderRadius: 5,
        marginBottom: 10,
    },
    buttonClose: {
        backgroundColor: '#2196F3',
        marginTop: 10,
        width: '100%',
        padding: 10,
        borderRadius: 10,
        alignItems: 'center',
    },
    buttonCancel: {
        backgroundColor: '#ff5c5c',
        marginTop: 10,
        width: '100%',
        padding: 10,
        borderRadius: 10,
        alignItems: 'center',
    },
    textStyle: {
        color: 'white',
        fontWeight: 'bold',
        textAlign: 'center',
    },
    modalText: {
        marginBottom: 15,
        textAlign: 'center',
        fontSize: 18,
        fontWeight: 'bold',
    },
});

export default LeaveRequests;
