import React from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity } from 'react-native';
import { RouteProp, useRoute, useNavigation, NavigationProp } from '@react-navigation/native';
import { RootStackParamList } from '../NavigationTypes';

const ClassroomHomeroom: React.FC = () => {
    const route = useRoute<RouteProp<RootStackParamList, 'ClassroomHomeroom'>>();
    const navigation = useNavigation<NavigationProp<RootStackParamList>>();
    const { years } = route.params;

    const handleYearPress = (year: string) => {
        navigation.navigate('HomeroomClasses', { year });
    };

    const renderYearItem = ({ item }: { item: string }) => (
        <TouchableOpacity style={styles.yearItem} onPress={() => handleYearPress(item)}>
            <Text style={styles.yearText}>Niên khóa: {item}</Text>
        </TouchableOpacity>
    );

    return (
        <View style={styles.container}>
            <Text style={styles.headerText}>Danh Sách Niên Khóa Chủ Nhiệm</Text>
            <FlatList
                data={years}
                renderItem={renderYearItem}
                keyExtractor={(item) => item.toString()}
                contentContainerStyle={styles.yearList}
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
    yearList: {
        marginTop: 20,
        width: '100%',
    },
    yearItem: {
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
    yearText: {
        fontSize: 18,
        fontWeight: 'bold',
    },
});

export default ClassroomHomeroom;
