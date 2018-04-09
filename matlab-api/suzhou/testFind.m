%% testFind.m
%  Simple script to find the electronic components.
%  
%  Written by:
%  Suzhou Li

%% Initialize the workspace
clear, close all

%% Initialize a cell array of images we want to go through
% fNames = { ...
%     '../../img/orig/L1.jpg', ...
%     '../../img/orig/L2.jpg', ...
%     '../../img/orig/L3.jpg'};

fNames = {'../../img/orig/L1.jpg'};

%% Find the components
components = find_electronic_components(fNames);