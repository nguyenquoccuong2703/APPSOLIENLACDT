import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, SafeAreaView } from 'react-native';
import { useNavigation } from '@react-navigation/native';

const LeaveRequestsTeacher: React.FC = () => {
    const navigation = useNavigation();

    return (
        <SafeAreaView style={styles.container}>
            <View style={styles.buttonContainer}>
                <TouchableOpacity style={styles.button} onPress={() => navigation.navigate('SubmitLeaveRequest' as never)}>
                    <Text style={styles.buttonText}>Gửi Yêu Cầu Nghỉ Phép</Text>
                </TouchableOpacity>
                <TouchableOpacity style={styles.button} onPress={() => navigation.navigate('ApproveLeaveRequest'as never)}>
                    <Text style={styles.buttonText}>Xác Nhận Nghỉ Phép</Text>
                </TouchableOpacity>
            </View>
        </SafeAreaView>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#f0f0f0',
    },
    buttonContainer: {
        width: '90%',
        justifyContent: 'space-around',
        alignItems: 'center',
    },
    button: {
        backgroundColor: '#2196F3',
        borderRadius: 20,
        padding: 10,
        elevation: 2,
        alignItems: 'center',
        width: '80%',
        marginVertical: 10,
    },
    buttonText: {
        color: 'white',
        fontWeight: 'bold',
    },
});
export default LeaveRequestsTeacher;
