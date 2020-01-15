import React, { useEffect, useState } from 'react';
import { Button, Slider, TextField } from '@material-ui/core';
import BootstrapSwitchButton from 'bootstrap-switch-button-react'
import './Ucu.css';

const sliderIntValues = [
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

const sliderFloatValues = [
    {
        value: 0.0,
        label: '0.0',
    },
    {
        value: 5.0,
        label: '5.0',
    },
    {
        value: 10.0,
        label: '10.0',
    },
];




export default function Ucu() {

    const [inputFieldInteger, setInputFieldInteger] = useState(44);
    const [sliderValue, setSliderValue] = useState(30);
    const [switchButton, setSwitchButton] = useState(true);
    const [someFloatValue, setSomeFloatValue] = useState(1.5);
    const [xmlUpload, setXmlUpload] = useState(null);
    const [showElement, setShowElement] = useState(false);

    function uploadXMLHandler(e) {
        setXmlUpload(e.target.files[0]);
    }



    useEffect(() => {
        if (xmlUpload != null) {
            var fileReader = new FileReader();
            fileReader.onload = () => {
                if (fileReader.result.includes("test_b")) {
                    setShowElement(true);
                } else {
                    setShowElement(false);
                }
            };
            fileReader.readAsText(xmlUpload);

        }
    });





    async function fetchSwitchButtonData() {
        fetch('/sb')
            .then(res => res.text())
    }

    async function fetchSwitchButtonPutData() {
        fetch('/sb', {
            method: 'PUT', body: switchButton ? '1' : '0'
        })
            .then(res => res.text())
    }




    async function fetchSliderValueData() {
        fetch('/sv')
            .then(res => res.text())
    }

    async function fetchSliderValuePutData() {
        let loopbackValue = sliderValue.toString();
        fetch('/sv', {
            method: 'PUT', body: loopbackValue
        })
            .then(res => res.text())
    }


    function handleNormalFieldInteger(event, value) {
        setInputFieldInteger(event.target.value);
    }

    function handleChange(event, value) {
        setSliderValue(value);
    }

    useEffect(() => {
        console.log("Switch button is turned " + (switchButton ? 'on' : 'off'));
        console.log('Slider value ' + sliderValue);
        fetchSwitchButtonData();
        fetchSwitchButtonPutData();
        fetchSliderValueData();
        fetchSliderValuePutData();
    });

    function handleSwitchButton() {
        setSwitchButton(!switchButton);
    }

    function handleFloatValue(event, value) {
        setSomeFloatValue(value);
    }

    function handleSubmit() {
        console.log(switchButton);
        console.log(sliderValue);
        console.log(someFloatValue);

        var builder = require('xmlbuilder');
        var xml = builder.create('config', { encoding: 'utf-8' })
            .ele('types').up()
            .ele('componenents')
            .ele('component', { 'name': 'AMOS_APP4UCU' })
            .ele('ports')
            .ele('receiver', { 'name': 'toApp' })
            .ele('element', {
                'name': 'test_u8',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'uint8'
            }, sliderValue).up()
            .ele('element', {
                'name': 'test_i8',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'sint8'
            }, sliderValue).up()
            .ele('element', {
                'name': 'test_u16',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'uint16'
            }, sliderValue).up()
            .ele('element', {
                'name': 'test_i16',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'sint16'
            }, sliderValue).up()
            .ele('element', {
                'name': 'test_u32',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'uint32'
            }, inputFieldInteger).up()
            .ele('element', {
                'name': 'test_i32',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'sint32'
            }, inputFieldInteger).up()
            .ele('element', {
                'name': 'test_r32',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'float32'
            }, someFloatValue).up()
            .ele('element', {
                'name': 'test_b',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'boolean',
            }, switchButton).up().up()
            .ele('sender', { 'name': 'fromApp' })
            .ele('element', {
                'name': 'test_u8',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'uint8'
            }, sliderValue).up()
            .ele('element', {
                'name': 'test_i8',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'sint8'
            }, sliderValue).up()
            .ele('element', {
                'name': 'test_u16',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'uint16'
            }, sliderValue).up()
            .ele('element', {
                'name': 'test_i16',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'sint16'
            }, sliderValue).up()
            .ele('element', {
                'name': 'test_u32',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'uint32'
            }, inputFieldInteger).up()
            .ele('element', {
                'name': 'test_i32',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'sint32'
            }, inputFieldInteger).up()
            .ele('element', {
                'name': 'test_r32',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'float32'
            }, someFloatValue).up()
            .ele('element', {
                'name': 'test_b',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'boolean',
            }, switchButton).up()
            .end({ pretty: true });
        console.log(xml)

        //we can use File as well but IE and Edge do not support that so it is better to use Blob because it is supported
        var FileSaver = require('file-saver');
        var blob = new Blob([xml], { type: "application/xml;charset=utf-8" });
        FileSaver.saveAs(blob, "AMOS_APP4UCU.xml");
    }

    const style = {
  
};




    return (
        <div className="Ucu">
            <h1 className="welcomeHeader">This is the webserver page for the UCU microcontroller. <br /></h1>
            <div className="uploadXML">
                <input
                    accept="image/*"
                    style={{ display: 'none' }}
                    id="raised-button-file"
                    multiple
                    type="file"
                    onChange={uploadXMLHandler}
                />
                <label htmlFor="raised-button-file">
                    <Button
                    style = {{
                        background: 'linear-gradient(45deg, #be2a92bd 30%, #FF8E53 90%)',
                        borderRadius: 3,
                        border: 0,
                        color: 'white',
                        height: 48,
                        padding: '0 30px',
                        boxShadow: '0 3px 5px 2px rgba(255, 105, 135, .3)',
                    }}
                     variant="contained" component="span" className="uploadButton">
                        Upload
                    </Button>
                </label>
            </div>
            <form onSubmit={handleSubmit}>
                {showElement ?
                    <div className="switchButtonDiv">
                        <h2>
                            Turn On and Off<BootstrapSwitchButton
                                checked={switchButton}
                                onstyle='success'
                                size='sm'
                                offstyle='danger'
                                onChange={handleSwitchButton}
                            />
                        </h2>
                    </div>

                    : null
                }

                <h2>
                    <div className="normalField">
                        <h2>
                            <TextField id="normalField" label="Input Integer Value here" variant="outlined"
                                InputLabelProps={{ style: { color: '#DBD5D5' }, }} onChange={handleNormalFieldInteger}>
                            </TextField>
                        </h2>
                    </div>
                    <div className="sliderHeader">Slide left or write by clicking on the point
                        <Slider
                            defaultValue={30}
                            aria-labelledby="discrete-slider"
                            valueLabelDisplay="auto"
                            step={1}
                            color='primary'
                            track='inverted'
                            onChange={handleChange}
                            marks={sliderIntValues}
                            min={0}
                            max={100}>
                        </Slider>
                    </div>
                </h2>
                <div>
                    <span className="sliderValue">Slider Integer Value {sliderValue}%</span>
                </div>

                <div className="floatValueDiv">
                    <Slider
                        defaultValue={1.5}
                        aria-labelledby="discrete-slider"
                        valueLabelDisplay="auto"
                        step={0.1}
                        color='primary'
                        track='inverted'
                        onChange={handleFloatValue}
                        marks={sliderFloatValues}
                        min={0.0}
                        max={10.0}>
                    </Slider>
                </div>
                <div>
                    <span className="sliderFloatValue">Slider Float Value {someFloatValue}</span>
                </div>

                <div className="downloadXML">
                    <Button 
                      style = {{
                        background: 'linear-gradient(45deg, #FF8E53 30%, #be2a92bd 90%)',
                        borderRadius: 3,
                        border: 0,
                        color: 'white',
                        height: 48,
                        padding: '0 30px',
                        boxShadow: '0 3px 5px 2px rgba(255, 105, 135, .3)',
                    }}
                    variant="contained"  type={"submit"} color="secondary">
                        Download XML
                    </Button>
                </div>
            </form>
        </div>
    );
}

