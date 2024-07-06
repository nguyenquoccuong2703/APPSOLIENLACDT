import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, FlatList, ActivityIndicator, Alert, TouchableOpacity } from 'react-native';
import { RouteProp, useRoute, useNavigation, NavigationProp } from '@react-navigation/native';
import { RootStackParamList } from '../NavigationTypes';

interface ClassItem {
    ClassId: number;
    ClassName: string;
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

const HomeroomClasses: React.FC = () => {
    const route = useRoute<RouteProp<RootStackParamList, 'HomeroomClasses'>>();
    const navigation = useNavigation<NavigationProp<RootStackParamList>>();
    const { year } = route.params;
    const [classes, setClasses] = useState<ClassItem[]>([]);
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        const fetchHomeroomClasses = async () => {
            setLoading(true);
            try {
                const response = await fetch(`http://192.168.137.1:3000/TeacherClassAssignment?IsHeadTeacher=1`);
                const data = await response.json();
                const classIds = data.map((assignment: any) => assignment.ClassId);

                const classesResponse = await fetch(`http://192.168.137.1:3000/Class`);
                const classesData = await classesResponse.json();
                const filteredClasses = classesData.filter((classItem: any) => classIds.includes(classItem.ClassId) && classItem.Khoahoc === year);

                setClasses(filteredClasses);
            } catch (error) {
                console.error('Lỗi khi lấy thông tin các lớp chủ nhiệm:', error);
                Alert.alert('Lỗi', 'Không thể lấy thông tin các lớp chủ nhiệm.');
            } finally {
                setLoading(false);
            }
        };

        fetchHomeroomClasses();
    }, [year]);

    const handleClassPress = (classId: number) => {
        navigation.navigate('StudentList', { classId });
    };

    const renderClassItem = ({ item }: { item: ClassItem }) => (
        <TouchableOpacity style={styles.classItem} onPress={() => handleClassPress(item.ClassId)}>
            <Text style={styles.classText}>Lớp: {getGradeName(item.GradeId)}{item.ClassName}</Text>
        </TouchableOpacity>
    );

    return (
        <View style={styles.container}>
            <Text style={styles.headerText}>Danh Sách Lớp Chủ Nhiệm - Niên Khóa {year}</Text>
            {loading ? (
                <ActivityIndicator size="large" color="#0000ff" />
            ) : (
                <FlatList
                    data={classes}
                    renderItem={renderClassItem}
                    keyExtractor={(item) => item.ClassId.toString()}
                    contentContainerStyle={styles.classList}
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
    },
    classText: {
        fontSize: 18,
        fontWeight: 'bold',
    },
});

export default HomeroomClasses;
