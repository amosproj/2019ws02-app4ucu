import React, {Component} from 'react';
import Ucu from './components/ucu/Ucu'
import './App.css';
import { Button } from 'react-bootstrap';

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
     <h1 className="welcomeHeader">This is our Intro page</h1>
     <p className="introParagraph">Please click on the button below to see the UCU component class</p>
<Button variant="primary" className="btn" onClick={this.displayUcu}> Click </Button>
 {this.state.display ?
           <Ucu /> :
           null
        }
    </div>
  );
}
}

export default App;
