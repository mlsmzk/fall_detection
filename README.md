# Fall Detection
QEA 3 Final Project
Charlie Babe, CJ Hilty, Miles Mezaki

This project aims to identify where a fall might have taken place based on signals acquired by accelerometer data. It is difficult to generalize since the phone doesn't necessarily fit into every pocket at the same angle and in the same direciton, but in collecting data for this experiment and analysis we put our phones long-way down and recorded data using the apps Phyphox and Matlab Mobile.

To run our first fall detector, use analyzeFall.m.
In Matlab, you will receive a 2x2 subplot and all possible falling points in an array by running "analyzeFall('example.mat',[low_bound, high_bound], threshold, skip)

Low_bound and high_bound are frequencies at which you think a fall might occur. We used values of 2 and 6 respectively.
Threshold is the amplitude at which we expected a fall to have occured. By default this is 7x10^3.
Skip ensures that the short time Fourier transform doesn't double count peaks in signal data, causing multiple of the same fall to be detected.
