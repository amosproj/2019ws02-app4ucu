import React, { Component } from 'react';
import Slider from '@material-ui/core/Slider';
import './Ucu.css';


//this is how yo make compomenets
const marks = [
  {
    value: 0,
    label: '0',
  },
  {
    value: 50,
    label: '50',
  },
  {
    value: 100,
    label: '100',
  },
];

function valuetext(value) {
  return `${value}`;
}

class Ucu extends Component {



  render() {
  return (
    <div className="Ucu">
      <h1>This is the UCU Compoment</h1>
      <h2>This slider later would be put to a good use
      <p className="sliderHeader">Slide left or write by clicking on the point<Slider
      defaultValue={30}
        aria-labelledby="discrete-slider"
        valueLabelDisplay="auto"
        step={5}
        marks={marks}
        min={0}
        max={100}>
      </Slider></p>

      </h2>
    </div>
  );
}
}

export default Ucu;
