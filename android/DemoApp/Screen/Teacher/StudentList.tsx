import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, FlatList, ActivityIndicator, Alert, TouchableOpacity, Button } from 'react-native';
import { RouteProp, useRoute, useNavigation, NavigationProp } from '@react-navigation/native';
import { RootStackParamList } from '../NavigationTypes';

interface StudentItem {
    StudentId: number;
    Name: string;
}

const StudentList: React.FC = () => {
    const route = useRoute<RouteProp<RootStackParamList, 'StudentList'>>();
    const navigation = useNavigation<NavigationProp<RootStackParamList>>();
    const { classId } = route.params;
    const [students, setStudents] = useState<StudentItem[]>([]);
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        const fetchStudents = async () => {
            setLoading(true);
            try {
                const response = await fetch(`http://192.168.137.1:3000/Student?ClassId=${classId}`);
                const data = await response.json();
                setStudents(data);
            } catch (error) {
                console.error('Lỗi khi lấy thông tin học sinh:', error);
                Alert.alert('Lỗi', 'Không thể lấy thông tin học sinh.');
            } finally {
                setLoading(false);
            }
        };

        fetchStudents();
    }, [classId]);

    const handleNotifyClassPress = () => {
        navigation.navigate('NotificationInput', { studentId: null, classId });
    };

    const handleStudentPress = (studentId: number) => {
        navigation.navigate('StudentDetail', { studentId });
    };

    const handleNotifyStudentPress = (studentId: number) => {
        navigation.navigate('NotificationInput', { studentId, classId: null });
    };

    const renderStudentItem = ({ item }: { item: StudentItem }) => (
        <View style={styles.studentItem}>
            <TouchableOpacity style={styles.studentInfo} onPress={() => handleStudentPress(item.StudentId)}>
                <Text style={styles.studentText}>Học sinh: {item.Name}</Text>
            </TouchableOpacity>
            <TouchableOpacity style={styles.notifyButton} onPress={() => handleNotifyStudentPress(item.StudentId)}>
                <Text style={styles.notifyButtonText}>Thông Báo</Text>
            </TouchableOpacity>
        </View>
    );

    return (
        <View style={styles.container}>
            <Text style={styles.headerText}>Danh Sách Học Sinh - Lớp {classId}</Text>
            <Button title="Gửi Thông Báo Cho Lớp" onPress={handleNotifyClassPress} color="#007bff" />
            {loading ? (
                <ActivityIndicator size="large" color="#0000ff" />
            ) : (
                <FlatList
                    data={students}
                    renderItem={renderStudentItem}
                    keyExtractor={(item) => item.StudentId.toString()}
                    contentContainerStyle={styles.studentList}
                />
            )}
        </View>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#f7f8fa',
        padding: 20,
    },
    headerText: {
        fontSize: 28,
        fontWeight: 'bold',
        color: '#333',
        marginBottom: 20,
    },
    studentList: {
        marginTop: 20,
        width: '100%',
    },
    studentItem: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        backgroundColor: '#fff',
        padding: 15,
        borderRadius: 10,
        marginBottom: 10,
        shadowColor: '#000',
        shadowOffset: {
            width: 0,
            height: 2,
        },
        shadowOpacity: 0.25,
        shadowRadius: 3.84,
        elevation: 5,
    },
    studentInfo: {
        flex: 1,
    },
    studentText: {
        fontSize: 18,
        fontWeight: 'bold',
    },
    notifyButton: {
        backgroundColor: '#007bff',
        padding: 10,
        borderRadius: 5,
    },
    notifyButtonText: {
        color: '#fff',
        fontSize: 16,
    },
});

export default StudentList;
