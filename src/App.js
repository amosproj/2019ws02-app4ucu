import React, {Component} from 'react';
import Ucu from './components/Ucu'
import './App.css';

class App extends Component {

  state = {
    display: false
  };

  displayUcu = () => {
    this.setState({
      display: !this.state.display
    })
}

  render() {
  return (
    <div className="App">
     
<button className="btn" onClick={this.displayUcu}> Click </button>
 {this.state.display ?
           <Ucu /> :
           null
        }
    </div>
  );
}
}

export default App;
