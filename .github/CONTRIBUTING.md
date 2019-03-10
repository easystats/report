# Contribution Guidelines
**All people are very much welcome to contribute to code, documentation, testing and suggestions.**

`report` is a beginner-friendly package. Even if you're new to all this open-source way of life, new to coding and github stuff, we encourage you to try submitting pull requests (PRs). 

- **"I'd like to help, but I'm not good enough with programming yet"**

It's alright, don't worry! You can always dig in the code, in the documentation or tests. There are always some typos to fix, some docs to improve, some details to add, some code lines to document, some tests to add... **Even the smaller PRs are appreciated**.

- **"I'd like to help, but I don't know where to start"**

You can look around the [issues section](https://github.com/neuropsychology/report/issues) to find some features / ideas / bugs to start working on. You can also open an issue just to say that you're there, we might have some ideas adapted to your skills. One of the "easy" way to start contributing is through tests improvement, which consists of building some edge-case models, and running them through all the functions with different arguments, to see if everything behaves as expected.

- **"I'm not sure if my suggestion or idea is worthwile"**

Enough with the impostor syndrom! All suggestions and opinions are good, and even if it's just a thought or so, it's always good to receive feedback.

- **"Why should I waste my time with this? Do I get any credit?"**

Authors of substantial contribution will be added within the [**authors**](https://neuropsychology.github.io/report/blob/master/DESCRIPTION) list. We're also very keen on including contributors to eventual publications.


**Anyway, starting is the most important! You will then enter a *whole new world, a new fantastic point of view*... So fork this repo, do some changes and submit them. We will then work together to make the best out of it :)**



## Code

- Please document and comment your code, so that the purpose of each step (or code line) is stated in a clear and understandable way.
- Before submitting a change, please read the [**R style guide**](https://style.tidyverse.org/) to keep some consistency in code formatting.
- Regarding the style guide, note this exception: we put readability and clarity before everything. Thus, we like underscores and full names (prefer `model_performance` over `modelperf` and `interpret_odds_logistic` over `intoddslog`).
- Before you start to code, make sure you're on the `dev` branch (the most "advanced"). Then, create a new branch named by your feature (e.g., `report_for_bigmodels`) and do your changes. Finally, submit your branch to be merged into the `dev` branch. Then, every now and then, the dev branch will merge into `master`, as a new package version.


## Useful Materials

- [Understanding the GitHub flow](https://guides.github.com/introduction/flow/)