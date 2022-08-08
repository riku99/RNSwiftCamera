import React, {useRef} from 'react';
import {
  findNodeHandle,
  NativeModules,
  requireNativeComponent,
  StyleSheet,
  TouchableOpacity,
  View,
} from 'react-native';

const NativeCamera = requireNativeComponent('Camera');
const CameraModule = NativeModules.CameraManager;

const App = () => {
  const cameraRef = useRef();

  const onPress = async () => {
    const node = findNodeHandle(cameraRef.current);
    await CameraModule.capture(node);
  };

  return (
    <View style={styles.container}>
      <NativeCamera style={styles.camera} ref={cameraRef} flash />
      <TouchableOpacity style={styles.button} onPress={onPress} />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  camera: {
    flex: 1,
  },
  button: {
    position: 'absolute',
    bottom: 60,
    width: 70,
    height: 70,
    borderRadius: 70,
    backgroundColor: 'white',
    alignSelf: 'center',
  },
});

export default App;
