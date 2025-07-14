#charset "utf8"
#pragma once
/* This optional header file defines templates for the Test class which is defined by tests2.t
Once you have added tests2.t to your project, you can #include this file
#include "tests2.h"
in each of your .t files to use these templates.
*/

Test template 'testName' [testList] @location? [testHolding]?;
Test template 'testName' [testList] [testHolding]? @location?;

/*
To use this extension, which was originally created by Jim Aikin based on an Inform7 tool,
 define Test objects like so:
    
someTest: Test 'foo' ['x me', 'i'];

at runtime you can play-back the script by using the TEST command
>TEST FOO
Testing sequence: "foo".

>x me
You look the same as usual.

>i
You are empty-handed.
*/
/*
You can optionally specify the location and possessions of the player character for the test.
This is convenient if a test must be in a certain place or needs certain items.

someTestInBedroom: Test 'bedroom' ['x bed', 'enter bed'] @Bedroom;

someTestWithMobile: Test 'mobile' ['x mobile', 'call bob'] [mobile_phone];


Unless you're planning to refer to the Test object in some other part of your code,
you can save a bit of typing by making it an anonymous object:
    
Test 'foo' ['x me', 'i'];  

Test 'bedroom' ['x bed', 'enter bed'] @Bedroom;

Test 'mobile' ['x mobile', 'call bob'] [mobile_phone];

*/