import {Button, SafeAreaView} from 'react-native';
// import RNShare from './native/RNShare';

const App = () => {
  return (
    <SafeAreaView style={{ flex: 1 }}>
      <Button
        title="Share"
        // onPress={() => RNShare.open({message: 'Bridge with Swift Dev.to Tutorial'})}
      />
    </SafeAreaView>
  );
};