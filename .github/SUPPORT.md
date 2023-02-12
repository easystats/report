# Getting help with `{report}`

Thanks for using `{report}`. Before filing an issue, there are a few places
to explore and pieces to put together to make the process as smooth as possible.

1. Try to see if updating to the latest versions of the *easystats* packages help solve 
your issue. You can do so easily with: `easystats::install_latest()`. After running this,
do not forget to refresh your R session. A good way to reset the R session in RStudio 
is to press the `Ctrl+Shift+F10` shortcut, and then reload the packages again.

2. If the above doesn't solve your problem, do not email the maintainer and do not 
send your data and script by email.

3. Instead, try making a minimal **repr**oducible **ex**ample using the 
[reprex](http://reprex.tidyverse.org/) package. If you haven't heard of or used a 
reprex before, you're in for a treat! Seriously, reprex will make all of your 
R-question-asking endeavors easier (which is a pretty insane ROI for the
five to ten minutes it'll take you to learn what it's all about). For additional 
reprex pointers, check out the [Get help!](https://www.tidyverse.org/help/) resource
used by the tidyverse team.

The act of attempting to write a reprex in itself will often lead to discovering 
the solution to your issue, so the process is oftentimes more important than the
outcome. Unless it's a bug, which the reprex has made clear.

4. In any case, armed with your reprex, the next step is to figure out where to ask:

  * If it's a question: start with StackOverflow. There are more people there to answer
    questions.
  * If it's a bug: you're in the right place, file an issue.
  * If you're not sure: let's [discuss](https://github.com/easystats/report/discussions) 
    it and try to figure it out! If your problem _is_ a bug or a feature request, 
    you can easily return here and report it.

5. Finally, before opening a new issue, be sure to 
[search issues and pull requests](https://github.com/easystats/report/issues) to 
make sure the bug hasn't been reported and/or already fixed in the development 
version. By default, the search will be pre-populated with `is:issue is:open`. You can
[edit the qualifiers](https://help.github.com/articles/searching-issues-and-pull-requests/)
(e.g. `is:pr`, `is:closed`) as needed. For example, you'd simply
remove `is:open` to search _all_ issues in the repo, open or closed.

Thanks for your help and may the Force (of R) be with you!