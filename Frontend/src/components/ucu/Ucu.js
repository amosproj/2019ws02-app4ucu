import React, { useEffect, useState } from 'react';
import { Button, Slider, TextField } from '@material-ui/core';
import BootstrapSwitchButton from 'bootstrap-switch-button-react'
import './Ucu.css';

const sliderIntValues = [
    {
        value: -100,
        label: '-100',
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


export default function Ucu() {

    //States
    const [inputFieldInteger, setInputFieldInteger] = useState(44);
    const [sliderIntegerValue, setSliderIntegerValue] = useState(30);
    const [switchButton, setSwitchButton] = useState(true);
    const [floatValue, setFloatValue] = useState(1.5);
    const [xmlUpload, setXmlUpload] = useState(null);
    const [showSwitchButton, setShowSwitchButton] = useState(false);
    const [showInputField, setShowInputField] = useState(false);
    const [showFloatField, setShowFloatField] = useState(false);
    const [showIntegerSlider, setShowIntegerSlider] = useState(false);

    //it is called whenever something is uploaded and saves the values of the uploaded file to the xmlUpload state
    function uploadXMLHandler(e) {
        setXmlUpload(e.target.files[0]);
    }

    //Handles XML show/hide elements
    useEffect(() => {
        if (xmlUpload != null) {
            var fileReader = new FileReader();
            var tmp = false;
            fileReader.onload = () => {
                if (fileReader.result.includes("test_b")) {
                    setShowSwitchButton(true);
                } else {
                    setShowSwitchButton(false);
                }
                if (fileReader.result.includes("test_r32")) {
                    setShowFloatField(true);
                } else {
                    setShowFloatField(false);
                }
                if (fileReader.result.includes("test_u8") || fileReader.result.includes("test_i8")) {
                    setShowInputField(true);
                } else {
                    setShowInputField(false);
                }
                ["test_u16", "test_i16", "test_u32", "test_i32"].forEach(elem => { if (fileReader.result.includes(elem)) tmp = true })
                if (tmp) {
                    setShowIntegerSlider(true);
                } else {
                    setShowIntegerSlider(false);
                }
            };
            fileReader.readAsText(xmlUpload);

        }
    });

    //async functions for frontend <--> backend values GET/PUT requests.
    //Any change on the WebApp will be directly sent to the backed.
    //Going to IPAddress/sb, /sv,  /sf, /ifv will display/print the value coming from the backend on the WebApp.
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

    async function fetchIntegerSliderValueData() {
        fetch('/sv')
            .then(res => res.text())
    }

    async function fetchIntegerSliderValuePutData() {
        let loopbackValue = sliderIntegerValue.toString();
        fetch('/sv', {
            method: 'PUT', body: loopbackValue
        })
            .then(res => res.text())
    }

    async function fetchFloatValueData() {
        fetch('/fv')
            .then(res => res.text())
    }

    async function fetchFloatValuePutData() {
        fetch('/fv', {
            method: 'PUT', body: floatValue.toString()
        })
            .then(res => res.text())
    }
    async function fetchInputFieldValueData() {
        fetch('/ifv')
            .then(res => res.text())
    }

    async function fetchInputFieldValuePutData() {
        fetch('/ifv', {
            method: 'PUT', body: inputFieldInteger.toString()
        })
            .then(res => res.text())
    }

    function handleNormalFieldInteger(event, value) {
        setInputFieldInteger(event.target.value);
    }

    function handleSliderIntegerValue(event, value) {
        setSliderIntegerValue(value);
    }

    //handles the state of the switch button
    function handleSwitchButton() {
        setSwitchButton(!switchButton);
    }
    //handles the state  and value of the switch button
    function handlefloatValue(event, value) {
        setFloatValue(event.target.value);
    }
    //handles the functions (asynchronously).
    //frontend <--> backend communication -- GET/PUT requests are fired
    //either when there are some changes in this states on the WebApp or when something comes back from the backend
    useEffect(() => {
        console.log("Switch button is turned " + (switchButton ? 'on' : 'off'));
        console.log('Slider value ' + sliderIntegerValue);
        fetchSwitchButtonData();
        fetchSwitchButtonPutData();
        fetchIntegerSliderValueData();
        fetchIntegerSliderValuePutData();
        fetchFloatValueData();
        fetchFloatValuePutData();
        fetchInputFieldValueData();
        fetchInputFieldValuePutData();
    });

    //Generates and downloads an XML file based on the states and values inside the main form
    function handleSubmit() {
        console.log(switchButton);
        console.log(sliderIntegerValue);
        console.log(floatValue);

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
            }, sliderIntegerValue).up()
            .ele('element', {
                'name': 'test_i8',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'sint8'
            }, sliderIntegerValue).up()
            .ele('element', {
                'name': 'test_u16',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'uint16'
            }, sliderIntegerValue).up()
            .ele('element', {
                'name': 'test_i16',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'sint16'
            }, sliderIntegerValue).up()
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
            }, floatValue).up()
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
            }, sliderIntegerValue).up()
            .ele('element', {
                'name': 'test_i8',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'sint8'
            }, sliderIntegerValue).up()
            .ele('element', {
                'name': 'test_u16',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'uint16'
            }, sliderIntegerValue).up()
            .ele('element', {
                'name': 'test_i16',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'sint16'
            }, sliderIntegerValue).up()
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
            }, floatValue).up()
            .ele('element', {
                'name': 'test_b',
                'init': '0',
                'min': '0',
                'max': '0',
                'type': 'boolean',
            }, switchButton).up()
            .end({ pretty: true });
        console.log(xml)

        //we can use File instead of Blob. However, neither does IE nor Edge support it.
        // That is why, is better to use Blob because it is supported on every browser
        var FileSaver = require('file-saver');
        var blob = new Blob([xml], { type: "application/xml;charset=utf-8" });
        FileSaver.saveAs(blob, "AMOS_APP4UCU.xml");
    }

    //HTML rendering of the UI elements
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
                        style={{
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
                {showSwitchButton ?
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

                {showInputField ?
                    <div className="normalField">
                        <h2>
                            <TextField id="normalField" label="Input Integer Value here" variant="outlined"
                                InputLabelProps={{ style: { color: '#DBD5D5' }, }} onChange={handleNormalFieldInteger}>
                            </TextField>
                        </h2>
                    </div>
                    : null
                }
                {showFloatField ?
                    <div className="InputFieldFloat">
                        <TextField type="float"
                            variant="outlined"
                            label="Float Values Fields"
                            InputLabelProps={{ style: { color: '#DBD5D5' }, }}
                            onChange={handlefloatValue} />
                    </div>
                    :
                    null
                }

                {showIntegerSlider ?
                    <div className="Integerslider">
                        <h2>
                            <div className="sliderHeader">Slide left or write by clicking on the point
                                <Slider
                                    defaultValue={30}
                                    aria-labelledby="discrete-slider"
                                    valueLabelDisplay="auto"
                                    step={1}
                                    color='primary'
                                    track='inverted'
                                    onChange={handleSliderIntegerValue}
                                    marks={sliderIntValues}
                                    min={0}
                                    max={100}>
                                </Slider>
                            </div>
                        </h2>
                        <div>
                            <span className="sliderIntegerValue">Slider Integer Value {sliderIntegerValue}%</span>
                        </div>
                    </div>
                    : null
                }
                <div className="downloadXML">
                    <Button
                        style={{
                            background: 'linear-gradient(45deg, #FF8E53 30%, #be2a92bd 90%)',
                            borderRadius: 3,
                            border: 0,
                            color: 'white',
                            height: 48,
                            padding: '0 30px',
                            boxShadow: '0 3px 5px 2px rgba(255, 105, 135, .3)',
                        }}
                        variant="contained" type={"submit"} color="secondary">
                        Download XML
                    </Button>
                </div>
            </form>
        </div>
    );
}