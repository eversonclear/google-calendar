import {TouchableOpacity, StyleSheet, Text, View, Image} from 'react-native';
import { Google } from '../icons/Google';

export default function GoogleButton({
  onPress,
  bgColor,
  color,
  title,
  disabled = false,
  style = {},
  loading = false,
  icon,
  width = '100%',
}) {
  const opacity = disabled ? 0.8 : 1;

  return (
    <TouchableOpacity
      onPress={onPress}
      style={[
        styles.buttonLogin,
        {
          backgroundColor: bgColor,
          opacity: loading ? 0.8 : opacity,
          width: width,
          paddingVertical: 15,
        },
        style,
      ]}
      disabled={disabled}>
      <View style={{flexDirection: 'row', alignItems: 'center'}}>
        <Google/> 
        <Text style={[styles.textButtonLogin, {color: color}]}>{title}</Text>
      </View>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  buttonLogin: {
    justifyContent: 'center',
    alignItems: 'center',
    padding: 10,
    borderRadius: 5,
    marginTop: 10,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 1,
    },
    shadowOpacity: 0.2,
    shadowRadius: 1.41,
    elevation: 2,
  },
  textButtonLogin: {
    fontSize: 14,
    fontWeight: 'bold',
  },
});
