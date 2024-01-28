# Tinnitus Masking Device (TMD)

## Abstract

Tinnitus, a persistent ringing in the ears, can significantly impair an individual's quality of life. The Tinnitus Masking Device (TMD) offers a comprehensive solution leveraging Raspberry Pi 3 or above with Ubuntu 18.02, Qt 5.4, and Python 3.9 with Firebase integration. This device combines pulse and galvanic sensor monitoring with personalized sound therapy to manage tinnitus effectively.

The TMD allows users to access a wide range of tinnitus sound frequencies (0 to 15000 Hz) through a user-friendly interface developed using Qt. Real-time monitoring of the user's physiological indicators (pulse and galvanic response) enables timely intervention in case of anomalies, providing relief through autonomous playback of reverse frequencies.

All relevant data, including physiological metrics and frequency usage, are transmitted to Firebase for comprehensive analysis. Python algorithms deployed on the backend process this data to predict recommended therapies and assess the user's current and future tinnitus stage.

To enhance user experience and mitigate external environmental influences, the TMD provides immersive distraction through 8D tunes across various categories.

This repository contains the codebase for the Tinnitus Masking Device, offering an open-source solution for managing tinnitus symptoms effectively.

## Features

- Access a wide range of tinnitus sound frequencies.
- Real-time monitoring of pulse and galvanic response.
- Autonomous playback of reverse frequencies for symptom relief.
- Data transmission and analysis through Firebase integration.
- Python algorithms for predictive therapy recommendations.
- Immersive distraction through 8D tunes.

## Requirements

- Raspberry Pi 3 or above with Ubuntu 18.02
- Qt 5.4
- Python 3.9
- Firebase integration

## Installation

1. Clone this repository to your Raspberry Pi device.
2. Install required dependencies: Qt, Python, Firebase.
3. Compile and run the Qt application.
4. Ensure Firebase integration for data transmission and analysis.

## Usage

1. Launch the TMD application on your Raspberry Pi.
2. Use the interface to select desired tinnitus sound frequencies.
3. Wear the device for real-time monitoring of physiological indicators.
4. Experience autonomous playback of reverse frequencies as needed.
5. Monitor Firebase dashboard for data analysis and therapy recommendations.

## Contributing

Contributions to the Tinnitus Masking Device project are welcome! Feel free to fork this repository and submit pull requests with your enhancements or bug fixes.

## License

This project is licensed under the [MIT License](LICENSE).

**Authors:** Sriharish T  
**Contact:** sriharish.cs21@bitsathy.ac.in 
