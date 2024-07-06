import React from 'react';
import { View, Text, StyleSheet, Image, ScrollView } from 'react-native';

function ContactsScreen() {
    return (
        <ScrollView contentContainerStyle={styles.container}>
            <Image 
                source={{ uri: 'https://ts.huit.edu.vn/Content/Images/LogoHUIT.png' }} 
                style={styles.logo}
            />
            <Text style={styles.title}>Thông tin liên hệ</Text>
            <View style={styles.infoContainer}>
                <View style={styles.infoItem}>
                    <Image 
                        source={{ uri: 'https://img.icons8.com/ios-filled/50/000000/marker.png' }} 
                        style={styles.icon}
                    />
                    <Text style={styles.text}>Địa chỉ: Tầng trệt nhà F, 140 Lê Trọng Tấn, P.Tây Thạnh, Q.Tân Phú, TP.HCM</Text>
                </View>
                <View style={styles.infoItem}>
                    <Image 
                        source={{ uri: 'https://img.icons8.com/ios-filled/50/000000/phone.png' }} 
                        style={styles.icon}
                    />
                    <Text style={styles.text}>Điện thoại: 028 6270 6275 - 096 205 1080</Text>
                </View>
                <View style={styles.infoItem}>
                    <Image 
                        source={{ uri: 'https://img.icons8.com/ios-filled/50/000000/email.png' }} 
                        style={styles.icon}
                    />
                    <Text style={styles.text}>Email: tuyensinh@huit.edu.vn</Text>
                </View>
            </View>
        </ScrollView>
    );
}

const styles = StyleSheet.create({
    container: {
        flexGrow: 1,
        justifyContent: 'center',
        alignItems: 'center',
        padding: 20,
        backgroundColor: '#f0f0f0',
    },
    logo: {
        width: 120,
        height: 120,
        marginBottom: 20,
        borderRadius: 60,
    },
    title: {
        fontSize: 28,
        fontWeight: 'bold',
        marginBottom: 20,
        color: '#4A00E0',
    },
    infoContainer: {
        backgroundColor: '#fff',
        padding: 20,
        borderRadius: 10,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: 5,
        elevation: 3,
        width: '100%',
    },
    infoItem: {
        flexDirection: 'row',
        alignItems: 'center',
        marginBottom: 15,
    },
    text: {
        fontSize: 18,
        color: '#333',
        marginLeft: 10,
        flex: 1,
        textAlign: 'left',
    },
    icon: {
        width: 24,
        height: 24,
    },
});

export default ContactsScreen;
