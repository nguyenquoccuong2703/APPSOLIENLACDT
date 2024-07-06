import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, SafeAreaView, ScrollView, Modal, TouchableOpacity } from 'react-native';
import { useUser } from '../UserContext';
import { Calendar } from 'react-native-calendars';

const Attendance: React.FC = () => {
    const { selectedStudent } = useUser();
    const [attendance, setAttendance] = useState<any[]>([]);
    const [error, setError] = useState<string | null>(null);
    const [selectedDate, setSelectedDate] = useState<string | null>(null);
    const [modalVisible, setModalVisible] = useState(false);

    const fetchAttendance = async () => {
        try {
            const response = await fetch(`http://192.168.137.1:3000/Attendance?student_id=${selectedStudent?.StudentId}`);
            const data = await response.json();
            setAttendance(data);
        } catch (error) {
            console.error('Error fetching attendance:', error);
            setError('Lỗi khi lấy thông tin điểm danh.');
        }
    };

    useEffect(() => {
        if (selectedStudent) {
            fetchAttendance();
        }
    }, [selectedStudent]);

    const getMarkedDates = () => {
        const markedDates: { [key: string]: { selected: boolean, selectedColor: string } } = {};
        attendance.forEach((att) => {
            let selectedColor = '';
            switch (att.status) {
                case 'present':
                    selectedColor = 'green';
                    break;
                case 'late':
                    selectedColor = 'yellow';
                    break;
                case 'absent':
                    selectedColor = 'red';
                    break;
                case 'excused':
                    selectedColor = 'purple';
                    break;
                case 'unexcused':
                    selectedColor = 'red';
                    break;
                default:
                    break;
            }
            markedDates[att.date] = { selected: true, selectedColor };
        });
        return markedDates;
    };

    const handleDayPress = (day: any) => {
        const date = day.dateString;
        const attendanceEntry = attendance.find(att => att.date === date);
        if (attendanceEntry && attendanceEntry.notes) {
            setSelectedDate(date);
            setModalVisible(true);
        }
    };

    return (
        <SafeAreaView style={styles.container}>
            <ScrollView contentContainerStyle={styles.scrollViewContainer}>
                <View style={styles.card}>
                    <Text style={styles.sectionText}>Điểm Danh</Text>
                    {error ? (
                        <Text style={styles.errorText}>{error}</Text>
                    ) : (
                        <Calendar
                            markedDates={getMarkedDates()}
                            onDayPress={handleDayPress}
                        />
                    )}
                </View>
                <View style={styles.legendCard}>
                    <Text style={styles.legendTitle}>Chú Thích:</Text>
                    <View style={styles.legendItem}>
                        <View style={[styles.legendColor, { backgroundColor: 'green' }]} />
                        <Text style={styles.legendText}>Có mặt</Text>
                    </View>
                    <View style={styles.legendItem}>
                        <View style={[styles.legendColor, { backgroundColor: 'yellow' }]} />
                        <Text style={styles.legendText}>Đến muộn</Text>
                    </View>
                    <View style={styles.legendItem}>
                        <View style={[styles.legendColor, { backgroundColor: 'red' }]} />
                        <Text style={styles.legendText}>Vắng mặt</Text>
                    </View>
                    <View style={styles.legendItem}>
                        <View style={[styles.legendColor, { backgroundColor: 'purple' }]} />
                        <Text style={styles.legendText}>Có phép nghỉ</Text>
                    </View>
                </View>
                <Modal
                    animationType="slide"
                    transparent={true}
                    visible={modalVisible}
                    onRequestClose={() => {
                        setModalVisible(!modalVisible);
                    }}
                >
                    <View style={styles.modalContainer}>
                        <View style={styles.modalView}>
                            <Text style={styles.modalText}>Lý do nghỉ ngày {selectedDate}</Text>
                            {attendance.find(att => att.date === selectedDate)?.notes ? (
                                <Text style={styles.modalContent}>{attendance.find(att => att.date === selectedDate)?.notes}</Text>
                            ) : (
                                <Text style={styles.modalContent}>Không có lý do</Text>
                            )}
                            <TouchableOpacity
                                style={[styles.button, styles.buttonClose]}
                                onPress={() => setModalVisible(!modalVisible)}
                            >
                                <Text style={styles.textStyle}>Đóng</Text>
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
    },
    errorText: {
        fontSize: 16,
        color: 'red',
    },
    legendCard: {
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
    legendTitle: {
        fontSize: 18,
        color: '#333',
        fontWeight: 'bold',
        marginBottom: 10,
    },
    legendItem: {
        flexDirection: 'row',
        alignItems: 'center',
        marginBottom: 5,
    },
    legendColor: {
        width: 20,
        height: 20,
        borderRadius: 10,
        marginRight: 10,
    },
    legendText: {
        fontSize: 16,
        color: '#555',
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
    },
    button: {
        borderRadius: 20,
        padding: 10,
        elevation: 2,
    },
    buttonClose: {
        backgroundColor: '#2196F3',
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
    modalContent: {
        marginBottom: 15,
        textAlign: 'center',
        fontSize: 16,
        color: '#333',
    },
});

export default Attendance;
