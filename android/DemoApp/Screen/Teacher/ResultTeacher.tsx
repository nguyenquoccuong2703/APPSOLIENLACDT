import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ActivityIndicator, Alert } from 'react-native';
import { useNavigation, NavigationProp } from '@react-navigation/native';
import { useUser } from '../UserContext';
import { RootStackParamList } from '../NavigationTypes';

const ResultTeacher: React.FC = () => {
    const navigation = useNavigation<NavigationProp<RootStackParamList>>();
    const { user } = useUser();
    const [loading, setLoading] = useState(false);

    const isJSON = (str: string) => {
        try {
            JSON.parse(str);
        } catch (e) {
            return false;
        }
        return true;
    };

    const fetchTeacherId = async (userId: number) => {
        try {
            const response = await fetch(`http://192.168.137.1:3000/Teacher?UserID=${userId}`);
            const data = await response.json();
            if (response.ok && data.length > 0) {
                return data[0].id; // Giả định rằng `id` là `TeacherID`
            } else {
                throw new Error('Không tìm thấy giáo viên với UserID này.');
            }
        } catch (error) {
            console.error('Lỗi khi lấy thông tin giáo viên:', error);
            throw error;
        }
    };

    const fetchHomeroomYears = async (teacherId: number): Promise<string[]> => {
        setLoading(true);
        try {
            const response = await fetch(`http://192.168.137.1:3000/TeacherClassAssignment?TeacherId=${teacherId}&IsHeadTeacher=1`);
            const responseText = await response.text();
            if (!response.ok || !isJSON(responseText)) {
                throw new Error(`Error ${response.status}: ${responseText}`);
            }
            const assignments: { ClassId: number }[] = JSON.parse(responseText);
            const classIds = assignments.map((assignment) => assignment.ClassId);
    
            const classesResponse = await fetch(`http://192.168.137.1:3000/Class`);
            const classesText = await classesResponse.text();
            if (!classesResponse.ok || !isJSON(classesText)) {
                throw new Error(`Error ${classesResponse.status}: ${classesText}`);
            }
            const classes: { ClassId: number; Khoahoc: string }[] = JSON.parse(classesText).filter((classItem : any) => classIds.includes(classItem.ClassId));
            const years = classes.map((classItem) => classItem.Khoahoc);
            setLoading(false);
            return [...new Set(years)]; // Loại bỏ các giá trị trùng lặp
        } catch (error) {
            setLoading(false);
            if (error instanceof Error) {
                console.error('Lỗi khi lấy thông tin các niên khóa:', error.message);
                Alert.alert('Lỗi', `Lỗi khi lấy thông tin các niên khóa: ${error.message}`);
            } else {
                console.error('Lỗi khi lấy thông tin các niên khóa:', error);
                Alert.alert('Lỗi', 'Lỗi không xác định khi lấy thông tin các niên khóa.');
            }
            return [];
        }
    };
    

    const fetchClasses = async (teacherId: number, isHeadTeacher: boolean) => {
        setLoading(true);
        try {
            const response = await fetch(`http://192.168.137.1:3000/TeacherClassAssignment?TeacherId=${teacherId}&IsHeadTeacher=${isHeadTeacher ? 1 : 0}`);
            const responseText = await response.text();
            if (!response.ok || !isJSON(responseText)) {
                throw new Error(`Error ${response.status}: ${responseText}`);
            }
            const assignments = JSON.parse(responseText);
            const classIds = assignments.map((assignment: any) => assignment.ClassId);

            const classesResponse = await fetch(`http://192.168.137.1:3000/Class`);
            const classesText = await classesResponse.text();
            if (!classesResponse.ok || !isJSON(classesText)) {
                throw new Error(`Error ${classesResponse.status}: ${classesText}`);
            }
            const classes = JSON.parse(classesText).filter((classItem: any) => classIds.includes(classItem.ClassId));
            setLoading(false);
            return classes;
        } catch (error) {
            setLoading(false);
            if (error instanceof Error) {
                console.error('Lỗi khi lấy thông tin các lớp:', error.message);
                Alert.alert('Lỗi', `Lỗi khi lấy thông tin các lớp: ${error.message}`);
            } else {
                console.error('Lỗi khi lấy thông tin các lớp:', error);
                Alert.alert('Lỗi', 'Lỗi không xác định khi lấy thông tin các lớp.');
            }
            return [];
        }
    };

    const handleClassroomHomeroomPress = async () => {
        if (user && user.id) {
            try {
                const teacherId = await fetchTeacherId(Number(user.id));
                const homeroomYears = await fetchHomeroomYears(teacherId);
                if (homeroomYears.length > 0) {
                    navigation.navigate('ClassroomHomeroom', { years: homeroomYears });
                } else {
                    Alert.alert('Thông báo', 'Không có niên khóa nào.');
                }
            } catch (error) {
                Alert.alert('Lỗi', 'Không tìm thấy giáo viên với UserID này.');
            }
        } else {
            Alert.alert('Lỗi', 'Thông tin giáo viên không hợp lệ.');
        }
    };

    const handleSubjectClassPress = async () => {
        if (user && user.id) {
            try {
                const teacherId = await fetchTeacherId(Number(user.id));
                const subjectClasses = await fetchClasses(teacherId, false);
                if (subjectClasses.length > 0) {
                    navigation.navigate('SubjectClasses', { subjectClasses });
                } else {
                    Alert.alert('Thông báo', 'Không có lớp bộ môn nào.');
                }
            } catch (error) {
                Alert.alert('Lỗi', 'Không tìm thấy giáo viên với UserID này.');
            }
        } else {
            Alert.alert('Lỗi', 'Thông tin giáo viên không hợp lệ.');
        }
    };

    return (
        <View style={styles.container}>
            <TouchableOpacity
                style={styles.button}
                onPress={handleClassroomHomeroomPress}
            >
                <Text style={styles.buttonText}>Lớp Chủ Nhiệm</Text>
            </TouchableOpacity>
            <TouchableOpacity
                style={styles.button}
                onPress={handleSubjectClassPress}
            >
                <Text style={styles.buttonText}>Lớp Bộ Môn</Text>
            </TouchableOpacity>
            {loading && <ActivityIndicator size="large" color="#0000ff" />}
        </View>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#f7f8fa',
        padding: 20,
    },
    button: {
        backgroundColor: '#4CAF50',
        padding: 15,
        borderRadius: 10,
        marginVertical: 10,
        width: '80%',
        alignItems: 'center',
        shadowColor: '#000',
        shadowOffset: {
            width: 0,
            height: 2,
        },
        shadowOpacity: 0.25,
        shadowRadius: 3.84,
        elevation: 5,
    },
    buttonText: {
        color: '#fff',
        fontSize: 18,
        fontWeight: 'bold',
    },
});

export default ResultTeacher;
