# Virtual Trainer

## Introduction
Welcome to the iOS app for our virtual trainer FYDP project. 

## Getting Started
### Amplify
Follow the following Amplify [link](https://sandbox.amplifyapp.com/test/fc466f4e-40ce-4cf8-b139-24bb7b5c9882). 
In order to pull down the latest Amplify models, you must first download the Amplify CLI with the following code:
```
curl -sL https://aws-amplify.github.io/amplify-cli/install | bash && $SHELL
```
Next, run the following command from your project's root folder:
```
amplify pull --sandboxId fc466f4e-40ce-4cf8-b139-24bb7b5c9882
```
Amplify dependencies are installed through CocoaPods. Open a terminal window and navigate to the location of the Xcode project for your app.
1. Initialize CocoaPods: 
    ```
    pod init
    ```
2. Install the Amplify pod into your project:
    ```
    pod install --repo-update
    ```
3. Follow these instructions in this StackOverflow [article](https://stackoverflow.com/questions/65261123/xcode-project-fails-to-find-the-amplifymodels-file-that-is-generated-for-ios-p) to add the Amplify files into your Xcode workspace.
License
-------

Copyright 2020 Google, Inc.

Licensed to the Apache Software Foundation (ASF) under one or more contributor
license agreements.  See the NOTICE file distributed with this work for
additional information regarding copyright ownership.  The ASF licenses this
file to you under the Apache License, Version 2.0 (the "License"); you may not
use this file except in compliance with the License.  You may obtain a copy of
the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
License for the specific language governing permissions and limitations under
the License.
