import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, ScrollView, ActivityIndicator } from 'react-native';
import { useUser } from '../UserContext';

interface Notification {
    NameContent: string;
    Content: string;
    Timestamp: string;
    id: string;
    ClassId: number;
    SenderId: number;
    RecipientIds: {
        IdClass: number | null;
        IdStudent: number | null;
    } | null;
    SenderName?: string; // Optional field for the sender's name
    SenderRole?: string; // Optional field for the sender's role (homeroom or subject teacher)
}

interface Student {
    StudentId: number;
    UserId: number;
    ClassId: number;
}

const Notifications: React.FC = () => {
    const { user } = useUser();
    const [notifications, setNotifications] = useState<Notification[]>([]);
    const [students, setStudents] = useState<Student[]>([]);
    const [loading, setLoading] = useState<boolean>(true);
    const [error, setError] = useState<string | null>(null);

    const fetchNotifications = async () => {
        try {
            const response = await fetch('http://192.168.137.1:3000/Notifications');
            const notificationsData: Notification[] = await response.json();

            const fetchSenderDetails = notificationsData.map(async (notification) => {
                const senderResponse = await fetch(`http://192.168.137.1:3000/Teacher?UserID=${notification.SenderId}`);
                const senderData = await senderResponse.json();
                const senderName = senderData.length > 0 ? senderData[0].Name : 'Unknown';

                if (senderData.length > 0) {
                    // Check if the teacher is a homeroom teacher for the class
                    const assignmentResponse = await fetch(`http://192.168.137.1:3000/TeacherClassAssignment?TeacherId=${senderData[0].id}&ClassId=${notification.ClassId}`);
                    const assignmentData = await assignmentResponse.json();

                    // Check if the teacher is a homeroom teacher (IsHeadTeacher === 1)
                    const isHomeroom = assignmentData.some((assignment: any) => assignment.IsHeadTeacher === 1);
                    const senderRole = isHomeroom ? 'chủ nhiệm' : 'bộ môn';

                    return { ...notification, SenderName: senderName, SenderRole: senderRole };
                } else {
                    return { ...notification, SenderName: 'Unknown', SenderRole: 'Unknown' };
                }
            });

            const notificationsWithSenderDetails = await Promise.all(fetchSenderDetails);
            setNotifications(notificationsWithSenderDetails);
        } catch (error) {
            console.error('Error fetching notifications:', error);
            setError('Lỗi khi lấy thông tin thông báo.');
        } finally {
            setLoading(false);
        }
    };

    const fetchStudents = async () => {
        try {
            const response = await fetch('http://192.168.137.1:3000/Student');
            const data: Student[] = await response.json();
            setStudents(data);
        } catch (error) {
            console.error('Error fetching students:', error);
            setError('Lỗi khi lấy thông tin học sinh.');
        }
    };

    useEffect(() => {
        fetchNotifications();
        fetchStudents();
    }, []);

    const getClassId = () => {
        if (user?.UserType === '1') {
            const student = students.find(student => student.UserId === parseInt(user.id));
            return student?.ClassId || null;
        }
        return null;
    };

    const getStudentId = () => {
        if (user?.UserType === '1') {
            const student = students.find(student => student.UserId === parseInt(user.id));
            return student?.StudentId || null;
        }
        return null;
    };

    const classId = getClassId();
    const studentId = getStudentId();

    const filteredNotifications = notifications.filter(notification => {
        const recipientIds = notification.RecipientIds || { IdClass: null, IdStudent: null };
        return (
            recipientIds.IdClass === classId ||
            recipientIds.IdStudent === studentId ||
            (recipientIds.IdClass === null && recipientIds.IdStudent === null)
        );
    });

    return (
        <ScrollView style={styles.container}>
            <Text style={styles.sectionText}>Thông Báo</Text>
            {loading ? (
                <ActivityIndicator size="large" color="#007bff" />
            ) : error ? (
                <Text style={styles.errorText}>{error}</Text>
            ) : filteredNotifications.length > 0 ? (
                filteredNotifications.map(notification => (
                    <View key={notification.id} style={styles.notificationItem}>
                        <View style={styles.notificationHeader}>
                            <Text style={styles.notificationTitle}>{notification.NameContent}</Text>
                        </View>
                        <Text>{notification.Content}</Text>
                        <Text style={styles.timestamp}>{notification.Timestamp}</Text>
                        <Text style={styles.senderName}>Gửi bởi: {notification.SenderName} ({notification.SenderRole})</Text>
                    </View>
                ))
            ) : (
                <Text style={styles.noNotifications}>Không có thông báo nào.</Text>
            )}
        </ScrollView>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#f0f0f0',
        padding: 20,
    },
    sectionText: {
        fontSize: 24,
        color: '#333',
        marginBottom: 20,
        fontWeight: 'bold',
        textAlign: 'center',
    },
    notificationItem: {
        marginBottom: 15,
        padding: 15,
        backgroundColor: '#fff',
        borderRadius: 10,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: 3,
        elevation: 2,
    },
    notificationHeader: {
        flexDirection: 'row',
        alignItems: 'center',
        marginBottom: 10,
    },
    notificationTitle: {
        fontSize: 18,
        fontWeight: 'bold',
        color: '#007bff',
    },
    timestamp: {
        fontSize: 12,
        color: '#888',
        marginTop: 5,
    },
    senderName: {
        fontSize: 14,
        color: '#555',
        marginTop: 5,
    },
    errorText: {
        color: 'red',
        textAlign: 'center',
        marginVertical: 20,
    },
    noNotifications: {
        textAlign: 'center',
        color: '#555',
        fontSize: 16,
        marginTop: 20,
    },
});

export default Notifications;
