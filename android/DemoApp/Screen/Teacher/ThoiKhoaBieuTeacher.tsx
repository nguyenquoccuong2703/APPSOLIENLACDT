import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

function ThoiKhoaBieuTeacher() {
    return (
        <View style={styles.container}>
            <Text style={styles.text}>Thoi Khoa Bieu Teacher</Text>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#fff',
    },
    text: {
        fontSize: 24,
    },
});

export default ThoiKhoaBieuTeacher;
