import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, SafeAreaView, ScrollView, TouchableOpacity, TextInput, Alert } from 'react-native';
import { useUser } from '../UserContext';

interface LeaveRequest {
    id: string;
    Userid: string;
    date: string;
    reason: string;
    status: string;
}

const SubmitLeaveRequestScreen: React.FC = () => {
    const { user } = useUser();
    const [leaveDate, setLeaveDate] = useState('');
    const [reason, setReason] = useState('');
    const [leaveRequests, setLeaveRequests] = useState<LeaveRequest[]>([]);
    const [error, setError] = useState<string | null>(null);

    const fetchLeaveRequests = async () => {
        try {
            const response = await fetch(`http://192.168.137.1:3000/LeaveRequests`);
            const data: LeaveRequest[] = await response.json();
            const userLeaveRequests = data.filter(request => request.Userid === user?.id);
            setLeaveRequests(userLeaveRequests);
        } catch (error) {
            console.error('Lỗi khi lấy thông tin xin nghỉ phép:', error);
            setError('Lỗi khi lấy thông tin xin nghỉ phép.');
        }
    };

    const submitLeaveRequest = async () => {
        if (!leaveDate || !reason) {
            setError('Vui lòng điền đầy đủ thông tin.');
            return;
        }

        try {
            const response = await fetch('http://192.168.137.1:3000/LeaveRequests', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    Userid: user?.id,
                    date: leaveDate,
                    reason: reason,
                    status: 'pending'
                }),
            });

            if (response.ok) {
                setLeaveDate('');
                setReason('');
                setError(null);
                Alert.alert('Gửi yêu cầu nghỉ phép thành công.');
                fetchLeaveRequests(); // Refresh the leave requests after submission
            } else {
                setError('Lỗi khi gửi yêu cầu nghỉ phép.');
            }
        } catch (error) {
            console.error('Lỗi khi gửi yêu cầu nghỉ phép:', error);
            setError('Lỗi khi gửi yêu cầu nghỉ phép.');
        }
    };

    useEffect(() => {
        fetchLeaveRequests();
    }, []);

    return (
        <SafeAreaView style={styles.container}>
            <ScrollView contentContainerStyle={styles.scrollViewContainer}>
                <View style={styles.card}>
                    <Text style={styles.sectionText}>Yêu Cầu Nghỉ Phép Đã Gửi</Text>
                    {leaveRequests.map((request, index) => (
                        <View key={index} style={styles.requestItem}>
                            <Text style={styles.requestText}>Ngày: {request.date}</Text>
                            <Text style={styles.requestText}>Lý do: {request.reason}</Text>
                            <Text style={styles.requestText}>Trạng thái: {request.status}</Text>
                        </View>
                    ))}
                </View>
                <View style={[styles.card, styles.cardSubmit]}>
                    <Text style={styles.sectionText}>Gửi Yêu Cầu Nghỉ Phép</Text>
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
                    <TouchableOpacity style={[styles.button, styles.buttonSubmit]} onPress={submitLeaveRequest}>
                        <Text style={styles.textStyle}>Gửi</Text>
                    </TouchableOpacity>
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
        paddingHorizontal: 10,
    },
    card: {
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
    },
    cardSubmit: {
        backgroundColor: '#e0f7fa',
    },
    sectionText: {
        fontSize: 22,
        color: '#333',
        marginBottom: 15,
        fontWeight: 'bold',
        textAlign: 'center',
    },
    input: {
        width: '100%',
        padding: 12,
        borderColor: '#ccc',
        borderWidth: 1,
        borderRadius: 8,
        marginBottom: 15,
        backgroundColor: '#fff',
    },
    button: {
        padding: 15,
        borderRadius: 25,
        alignItems: 'center',
        marginTop: 10,
    },
    buttonSubmit: {
        backgroundColor: '#00796b',
    },
    textStyle: {
        color: 'white',
        fontWeight: 'bold',
        fontSize: 16,
    },
    errorText: {
        fontSize: 16,
        color: 'red',
        textAlign: 'center',
        marginBottom: 10,
    },
    requestItem: {
        padding: 15,
        backgroundColor: '#f8f8f8',
        borderRadius: 10,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 1 },
        shadowOpacity: 0.1,
        shadowRadius: 3,
        elevation: 2,
        marginBottom: 10,
    },
    requestText: {
        fontSize: 16,
        color: '#555',
    },
});

export default SubmitLeaveRequestScreen;
