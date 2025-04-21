---
layout: post
title: Sprint 1 - Calculator
description: Calculator
type: collab
categories:
  - Sprint 1
comments: True
---

<!-- 
Hack 0: Right justify the result
Hack 1: Test conditions on small, big, and decimal numbers, and report on findings. Fix issues.
Hack 2: Add the common math operation that is missing from the calculator
Hack 3: Implement 1 number operation (ie SQRT) 
-->

<!-- 
HTML implementation of the calculator. 
-->

<!-- 
    Style and Action are aligned with HRML class definitions
    style.css contains the majority of style definitions (number, operation, clear, and equals)
    - The div calculator container sets 4 elements to a row
    The background is credited to Vanta JS and is implemented at the bottom of this page
-->
<style>
    button {
    width: auto;
    height: auto;
    border-radius: 10px;
    background-color: #21807c;
    border: 3px solid black;
    font-size: 1.5em;

    display: flex;
    justify-content: center;
    align-items: center;

    grid-column: span 1;
    grid-row: span 1;

    transition: all 0.5s; 
  }

  /* define class for redifined button */
  .button {
    @include button;
    @include button:hover;
  }

   /* darkens the background color on hover to create a selecting effect */
  button:hover {
    background-color: #00404D;
  }

  /* "row style" is flexible size and aligns pictures in center */
  .row {
    align-items: center;
    display: flex;
  }

  /* "column style" is one-third of the width with padding */
  .column {
    flex: 16.66%;
    padding: 3px;
  }
  
  /* class to create the calculator's container; uses CSS grid dsiplay to partition off buttons */
  .calculator-container { 
    width: 180vw; /* this width and height is specified for mobile devices by default */
    height: 160vh;
    margin: 0 auto;
  
    display: grid;
    grid-template-columns: repeat(4, 1fr); /* fr is a special unit; learn more here: https://css-tricks.com/introduction-fr-css-unit/  */
    grid-template-rows: 0.5fr repeat(4, 1fr);
    gap: 15px 15px;
  }
  
  @media (min-width: 600px) { 
    .calculator-container {
        width: 40vw;
        height: 90vh;
    }
  }

  /* styling for the calculator number button */
  .calculator-number {
    @extend .button;
  }

  /* styling for the calculator operation button */
  .calculator-operation {
    @extend .button;
  }
  
  /* styling for the calculator clear button */
  .calculator-clear {
    @extend .button;
    background-color: #e68b1c;
  }
  .calculator-clear:hover {
    @extend .button:hover;
    background-color: #662200;
  }
  
  /* styling for the calculator equals button */
  .calculator-equals {
    @extend .button;
    background-color: #e70f0f;
  }
  .calculator-equals:hover {
    @extend .button:hover;
    background-color: #800015;
  }

  /* define class for redifined button */
  
  .calculator-output {
    /* calulator output 
      top bar shows the results of the calculator;
      result to take up the entirety of the first row;
      span defines 4 columns and 1 row
    */
    grid-column: span 4;
    grid-row: span 1;
  
    border-radius: 10px;
    padding: 0.25em;
    font-size: 40px;
    border: 5px solid black;

    float: right;
    width: 670px;
    direction: rtl;
  
    display: flex;
    align-items: right;
  }
</style>

<!-- Add a container for the animation -->


<div id="animation">
  <div class="calculator-container">
      <!--result-->
      <div class="calculator-output" id="output">0</div>
      <!--row 1-->
        <button class="calculator-number" type="button">1</button>
        <button class="calculator-number" type="button">2</button>
        <button class="calculator-number" type="button">3</button>
        <button class="calculator-operation" type="button">+</button>
        <!--row 2-->
        <button class="calculator-number" type="button">4</button>
        <button class="calculator-number" type="button">5</button>
        <button class="calculator-number" type="button">6</button>
        <button class="calculator-operation" type="button">-</button>
        <!--row 3-->
        <button class="calculator-number" type="button">7</button>
        <button class="calculator-number" type="button">8</button>
        <button class="calculator-number" type="button">9</button>
        <button class="calculator-operation" type="button">*</button>
        <!--row 4-->
        <button class="calculator-clear" type="button">A/C</button>
        <button class="calculator-number" type="button">0</button>
        <button class="calculator-number" type="button">.</button>
        <button class="calculator-operation" type="button">/</button>
        <!--row 4 -->
        <button class="calculator-equals" type="button">=</button>
        <button class="calculator-operation" type="button">^</button>
  </div>
</div>

<!-- JavaScript (JS) implementation of the calculator. -->
<script>
// initialize important variables to manage calculations
var firstNumber = null;
var operator = null;
var nextReady = true;
// build objects containing key elements
const output = document.getElementById("output");
const numbers = document.querySelectorAll(".calculator-number");
const operations = document.querySelectorAll(".calculator-operation");
const clear = document.querySelectorAll(".calculator-clear");
const equals = document.querySelectorAll(".calculator-equals");

// Number buttons listener
numbers.forEach(button => {
  button.addEventListener("click", function() {
    number(button.textContent);
  });
});

// Number action
function number (value) { // function to input numbers into the calculator
    if (value != ".") {
        if (nextReady == true) { // nextReady is used to tell the computer when the user is going to input a completely new number
            output.innerHTML = value;
            if (value != "0") { // if statement to ensure that there are no multiple leading zeroes
                nextReady = false;
            }
        } else {
            output.innerHTML = output.innerHTML + value; // concatenation is used to add the numbers to the end of the input
        }
    } else { // special case for adding a decimal; can't have two decimals
        if (output.innerHTML.indexOf(".") == -1) {
            output.innerHTML = output.innerHTML + value;
            nextReady = false;
        }
    }
}

// Operation buttons listener
operations.forEach(button => {
  button.addEventListener("click", function() {
    operation(button.textContent);
  });
});

// Operator action
function operation (choice) { // function to input operations into the calculator
    if (firstNumber == null) { // once the operation is chosen, the displayed number is stored into the variable firstNumber
        firstNumber = parseFloat(output.innerHTML);
        nextReady = true;
        operator = choice;
        return; // exits function
    }
    // occurs if there is already a number stored in the calculator
    firstNumber = calculate(firstNumber, parseFloat(output.innerHTML)); 
    operator = choice;
    output.innerHTML = firstNumber.toString();
    nextReady = true;
}

// Calculator
function calculate (first, second) { // function to calculate the result of the equation
    let result = 0;
    switch (operator) {
        case "+":
            result = first + second;
            break;
        case "-":
            result = first - second;
            break;
        case "*":
            result = first * second;
            break;
        case "/":
            result = first / second;
            break;
        case "^":
            result = Math.pow(first, second)
            break;
        default: 
            break;
    }
    return result;
}

// Equals button listener
equals.forEach(button => {
  button.addEventListener("click", function() {
    equal();
  });
});

// Equal action
function equal () { // function used when the equals button is clicked; calculates equation and displays it
    firstNumber = calculate(firstNumber, parseFloat(output.innerHTML));
    output.innerHTML = firstNumber.toString();
    nextReady = true;
}

// Clear button listener
clear.forEach(button => {
  button.addEventListener("click", function() {
    clearCalc();
  });
});

// A/C action
function clearCalc () { // clears calculator
    firstNumber = null;
    output.innerHTML = "0";
    nextReady = true;
}
</script>

<!-- 
Vanta animations just for fun, load JS onto the page
-->
<script src="../../../assets/js/three.r119.min.js"></script>
<script src="../../../assets/js/vanta.halo.min.js"></script>
<script src="../../../assets/js/vanta.birds.min.js"></script>
<script src="../../../assets/js/vanta.net.min.js"></script>
<script src="../../../assets/js/vanta.rings.min.js"></script>

<script>
// setup vanta scripts as functions
var vantaInstances = {
  halo: VANTA.HALO,
  birds: VANTA.BIRDS,
  net: VANTA.NET,
  rings: VANTA.RINGS
};

// obtain a random vanta function
var vantaInstance = vantaInstances[Object.keys(vantaInstances)[Math.floor(Math.random() * Object.keys(vantaInstances).length)]];

// run the animation
vantaInstance({
  el: "#animation",
  mouseControls: true,
  touchControls: true,
  gyroControls: false
});
</script>

