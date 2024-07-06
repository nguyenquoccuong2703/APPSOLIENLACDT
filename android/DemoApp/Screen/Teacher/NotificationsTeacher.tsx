// NotificationsTeacher.tsx
import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Alert } from 'react-native';
import { useNavigation, NavigationProp } from '@react-navigation/native';
import { useUser } from '../UserContext';
import { RootStackParamList } from '../NavigationTypes';

const NotificationsTeacher: React.FC = () => {
    const navigation = useNavigation<NavigationProp<RootStackParamList>>();
    const { user } = useUser();



    const handleSubjectClassPress = () => {
        if (user && user.id) {
            navigation.navigate('NotificationInput2', { userId: user.id });
        } else {
            Alert.alert('Error', 'Invalid teacher information.');
        }
    };

    return (
        <View style={styles.container}>
            <TouchableOpacity
                style={styles.button}
            >
                <Text style={styles.buttonText}>Send Homeroom Notification</Text>
            </TouchableOpacity>
            <TouchableOpacity
                style={styles.button}
                onPress={handleSubjectClassPress}
            >
                <Text style={styles.buttonText}>Send Subject Class Notification</Text>
            </TouchableOpacity>
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

export default NotificationsTeacher;
