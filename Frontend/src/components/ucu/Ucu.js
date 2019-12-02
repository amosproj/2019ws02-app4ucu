import React, {useState} from 'react';
import { Slider } from '@material-ui/core';
import BootstrapSwitchButton from 'bootstrap-switch-button-react'
import './Ucu.css';

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

let switchButton = false;

function switchButtonChange() {
  switchButton = !switchButton;
  console.log("Switch button is turned " + (switchButton ? 'on' : 'off'));

}

export default function Ucu() {

  const [sliderValue, setSliderValue] = useState(30);

  function handleChange(event, value) {
    setSliderValue(value);
    console.log("Value is " + value, "Type is " + typeof (value));
  }


  return (
    <div className="Ucu">
      <h1 className="welcomeHeader">This is the welcome page of the UCU microcontroller. <br />
      You can control it through this application. Just use the options below</h1>
        <div className="switchButtonDiv">
          <h2>
          Turn On and Off<BootstrapSwitchButton
          checked={switchButton}
          onstyle='success'
          size='sm'
          offstyle='danger'
          onChange={switchButtonChange}
        />
        </h2>
        </div>
      <h2>
      <div className="sliderHeader">Slide left or write by clicking on the point 
      <Slider
          defaultValue={30}
          aria-labelledby="discrete-slider"
          valueLabelDisplay="auto"
          step={1}
          color='primary'
          track='inverted'
          onChange={handleChange}
          marks={marks}
          min={0}
          max={100}>
        </Slider>
        </div>
        <span className="sliderValue">Slider value {sliderValue}%</span>
      </h2>

      <div className="xml">
    HERE is the place for the XML table, upload, etc.
      </div>
    </div>
  );
}

