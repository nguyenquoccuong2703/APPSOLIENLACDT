import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity, Button } from 'react-native';
import { RouteProp, useRoute, useNavigation, NavigationProp } from '@react-navigation/native';
import { RootStackParamList } from '../NavigationTypes';
import { useUser } from '../UserContext'; // Adjust the path to your UserContext

interface Class {
    ClassId: number;
    ClassName: string;
    AcademicYear: number;
    GradeId: number;
}

// Function to get the grade name from the GradeId
const getGradeName = (gradeId: number) => {
    switch (gradeId) {
        case 10:
            return '10';
        case 11:
            return '11';
        case 12:
            return '12';
        default:
            return 'Unknown Grade';
    }
};

const SubjectClasses: React.FC = () => {
    const route = useRoute<RouteProp<RootStackParamList, 'SubjectClasses'>>();
    const navigation = useNavigation<NavigationProp<RootStackParamList>>();
    const { subjectClasses } = route.params;
    const { user } = useUser();
    const [filteredClasses, setFilteredClasses] = useState<Class[]>([]);

    useEffect(() => {
        const fetchTeacherAndAssignments = async () => {
            try {
                const teacherResponse = await fetch(`http://192.168.137.1:3000/Teacher?UserID=${user?.id}`);
                const teacherData = await teacherResponse.json();
                const currentTeacher = teacherData[0]; // Assuming the teacher data is in an array

                const assignmentsResponse = await fetch(`http://192.168.137.1:3000/TeacherClassAssignment?TeacherId=${currentTeacher.id}`);
                const assignments = await assignmentsResponse.json();

                const classIds = assignments.filter((assignment: any) => assignment.IsHeadTeacher === 0).map((assignment: any) => assignment.ClassId);
                const filtered = subjectClasses.filter((subjectClass: Class) => classIds.includes(subjectClass.ClassId));
                setFilteredClasses(filtered);
            } catch (error) {
                console.error('Error fetching teacher and assignments:', error);
            }
        };

        if (user?.id) {
            fetchTeacherAndAssignments();
        }
    }, [user?.id, subjectClasses]);

    const handleClassPress = (classId: number) => {
        navigation.navigate('ClassScores', { classId });
    };

    const handleNotifyClassPress = (classId: number) => {
        navigation.navigate('NotificationInput', { classId, studentId: null });
    };

    const renderClassItem = ({ item }: { item: Class }) => (
        <View style={styles.classItem}>
            <TouchableOpacity onPress={() => handleClassPress(item.ClassId)}>
                <Text style={styles.className}>Lớp: {getGradeName(item.GradeId)}{item.ClassName}</Text>
                <Text>Năm học: {item.AcademicYear}</Text>
            </TouchableOpacity>
            <Button title="Gửi Thông Báo" onPress={() => handleNotifyClassPress(item.ClassId)} />
        </View>
    );

    return (
        <View style={styles.container}>
            <Text style={styles.headerText}>Danh Sách Lớp Bộ Môn</Text>
            <FlatList
                data={filteredClasses}
                renderItem={renderClassItem}
                keyExtractor={(item) => item.ClassId.toString()}
                contentContainerStyle={styles.classList}
            />
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
    classList: {
        marginTop: 20,
        width: '100%',
    },
    classItem: {
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
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
    },
    className: {
        fontSize: 18,
        fontWeight: 'bold',
    },
});

export default SubjectClasses;
