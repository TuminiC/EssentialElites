# The MindGuard
The MindGuard app provides a comprehensive set of features for mental health support.

## Project summary

### The issue we are hoping to solve

We sought to address the challenge of providing immediate, personalized support for individuals in mental health crises, as existing resources are often hard to navigate and not tailored to urgent needs. 
The app offers an AI assistant, clinic locator, and meditation generator to deliver quick, accessible and relevant help during critical moments.

### How our technology solution can help

An AI-driven, mental health crisis support app immediately available on mobile devices.

### Our idea

Many people struggle to open up about their mental health due to stigma or not knowing where to turn. This app is designed to break those barriers and provide a safe, non-judgmental space for support. 

__Key Questions__:
  - *__Have you struggled to talk about your mental health?__* The AI assistant offers a safe space to share thoughts without fear of judgment.
  - *__Did you solve these challenges alone?__* The app guides users with personalized support, helping them take the first step toward resolution.
  - *__Would chatting with someone help?__* The app connects users to immediate AI support, with future options for teletherapy and peer support. 

These questions drive our design, ensuring users can easily access help, whether they're ready to talk to someone or need a starting point.

__Key Features__: 
1. *__AI-based health Chat__*: The AI assistant is the centerpiece of the MindGuard app, providing real-time support for users who need guidance, information, or emotional support. By leveraging IBM Watson's natural language processing capabilities, the AI assistant can interact with users in a conversational manner, offering personalized responses based on their queries. The AI assistant is designed to address a range of topics related to mental health, from stress management techniques and coping strategies to answering general questions about mental well-being. Its ability to continuously learn and adapt ensures that the more it interacts with users, the more relevant and personalized its responses become. This feature helps users feel heard and supported in times of need, offering a virtual companion that can provide assistance at any time.

2. *__Nearby Clinic Locator__*: The second core feature of the app is the nearby clinic locator, which helps users quickly find medical assistance in their area. By utilizing location services, the app detects the user's current location and lists nearby healthcare facilities, including mental health clinics and emergency services. This feature is particularly useful for user experiencing a mental health crisis who need immediate access to professional help. The locator provides essential information such as clinic address, contact numbers, hours of operation, and the types of services offered. By integrating this functionality, the app ensures that users can quickly find and reach out of healthcare providers when they need urgent care.

3. *__AI-based Meditation Guide__*: The MindGuard app also emphasizes mindfulness and emotional well-being through its meditation feature. The random meaningful meditation generator provides users with guided meditation sessions tailored to their emotional state or mental health needs, Each time the user engages with this feature, a unique meditation session is generated, helping them practice mindfulness, relaxation, or stress relief. The library of meditations covers various themes, such as deep breathing, relaxation techniques, and mental states. By offering randomized sessions, the app keeps the experience fresh and personalized, encouraging regular use as part of the user's mental health routine.

__Technical Overview__:
The frond-end of the MindGuard app is developed using Flutter, a versatile framework that allows developers to build cross-platform application with a single codebase. This approach ensures that the app delivers a consistent experience across both IOS and Android platforms, with smooth performance and an intuitive user interface. 
On the back-end, Python powers the app's business logic and API communication. The app makes API calls to IBM Watson AI, which handles the AI assistant's natural language processing and response generation. This architecture ensures that the app can manage large volumes of data, interact with users in real-time, and provide reliable, responsive service.

__Benefits of the Solution__:
The MindGuard app combines these three features to offer a comprehensive tool for mental health support. By integrating real-time AI assistance, location-based healthcare access, and personalized mindfulness exercises, the app empowers users to take control of their mental well-being. Whether users need urgent medical help, emotional support, or a moment of calm, the app provides solutions that are both practical and meaningful. Overall, the MindGuard app is a powerful resource for individuals in need of mental health support, offering a mix of technological innovation and compassionate care to help users through challenging moments.

More detail is available in our [Description document](./docs/DESCRIPTION.md).

## Technology implementation

### IBM watsonx product(s) used

**Featured watsonx products**

- [watsonx.ai](https://www.ibm.com/products/watsonx-ai) - We used it's foundational model to generate response.

### Solution architecture

![SolutionArch](https://github.com/user-attachments/assets/f34e92a5-f34e-4cae-8851-a3a36d40488b)

## Presentation materials

### Solution demo video

[Watch the video](https://www.youtube.com/watch?v=OO4ODOJummU)

### Project development roadmap

The project currently does the following things.

- AI-based health Chat
- Nearby Clinic Locator
- AI-based Meditation Guide

See below for our current and proposed schedule on next steps after Call for Code 2024 submission.
![roadMap](https://github.com/user-attachments/assets/87249e4d-21a8-4f04-b7dc-f499512032e9)

## Additional details

### How to run the project

See [Getting Started](./frontend/README.md)

### Authors

* Nicho Duan
* Hui Wang
* [Meet Mehta](https://github.com/meetmehta1198)
* [Tumini Cookey](https://github.com/TuminiC)
* [Kenechukwu Nnodu](https://github.com/kenextra)
