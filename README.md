# Serendipity
## Problem
As high school students, we have experienced all-too-human emotional outbreaks and depressive episodes; Kevin sleeping only 4 hours per day because of insomnia, Akshay gaining 12 pounds in a week, and Christopher suffering from impulse control disorder and test anxiety. We realized that depression is an extremely complex, nuanced issue that is hard to speak about to others. Sometimes, we don't know what's wrong. It's this fear about the unknown that we have to grapple with and we are unable to capture these feelings in front of counselors we've never met before. But, it's not just us. Over 300 million people worldwide suffer from depression with women twice as likely to have it. That's why we present Serendipity, an application that allows you to understand your feelings, problems, and maybe even something serendipitous.

## Target Customers
Our primary target market is young adults in secondary school and university. Between 20-30% of young adults report symptoms of depression with 9% of high school students attempting suicide this past year which is why they make up a major portion of our customer segment. Our secondary target market is counselors working in the over 12,000 mental health facilities across the United States who utilize the app to provide personalized guidance to their patients. Introspection and the understanding of one's mental state is critical to self-treat depression and Serendipity will ease the process for young adults.

## Solution
Serendipity has three major features to improve mental health around the world. We first utilize a biometric encryption algorithm that authenticates users based on FaceID to ensure the privacy of the usage of Serendipity. Each user is then authenticated through Google's Firebase, receiving a personalized experience and the ability to review past reports.

Anxiety Tracker - Our mobile app utilizes a sentiment analyzer and natural language processing based on the VADER Lexicon to detect the polarity of the speech from the transcript sent in through the records. Our iOS application first records the user's speech and then creates a request that is sent to a REST API with the output being the anxiety level of the user. 

Depression Self-Test - The transcript is also sent to our REST API's depression detection function which provides an early-stage diagnosis of whether the user is depressed or not. We detect depression utilizing a Bidirectional LSTM Neural Network with GloVe Embeddings which is trained over 200,000 tweets on Twitter. 

Pure Serendipity - The user is able to log down their activities and mood levels and the app, using correlative analysis, will automatically show the top activities that make them happy and excited. Who knows? You might be able to find your own serendipity of hobbies and fun that you can enjoy!

## Marketing Channels
We have three major marketing channels--social media, word of mouth, and pay-per-click advertising. We will utilize Twitter to provide constant tweets and updates to our applications, Reddit to create unique sub-communities that provide new ideas and feedback, and Facebook through targeted ads that reach people of all ages. Our passive channel is word of mouth which will help us generate popularity through shares between friends and family. Pay-per-click advertising will come in the form of Google Ads and Instagram Ads, redirecting people to our app with a simple click.

## Revenue Streams
Our revenue comes through two forms: licensing of our application to mental health facilities and a PRO version of Serendipity. We will license our applications to counselors in hospitals, wards, and schools so that they can help their patients, friends, and students to the best of their abilities. A PRO version will allow us to generate revenue through subscriptions that will unlock new features such as access to beta-releases, our API, and much more.

## Future Rollouts
Serendipity is the world's first application that helps people with severe depression through depression detection and speech analysis. We will be obtaining a utility patent for our machine learning algorithms and application design, ensuring a unique experience that can't be replicated. Our business model is unique because we will partner with mental health facilities across the world before any other similar application and also have our own application to provide users with both opportunities to use the application. Also, Serendipity has low distribution costs because deploying to the App Store and Google Play Store only takes $125. We will constantly develop the application and have a technical strength that will position Serendipity as the leading mental health tool in the industry.
