# quran-project
The Humble Foundation Qur'an Project in LaTeX format.

See [the project page](http://humblefoundation.org/quran) and [this introductory blog post](http://www.humblefoundation.org/blog/our-first-blog-post-on-relocation-and-translation), as well as [this one](http://www.humblefoundation.org/blog/publishing-a-book-with-latex-part-one).

#view the latest PDF

You can view the latest PDF [here](https://github.com/humblefoundation/quran-project/blob/master/quran-project.pdf), and download a copy [here](https://github.com/humblefoundation/quran-project/raw/master/quran-project.pdf). Bear in mind that we haven't started doing any work on layout or fonts, so it's not likely to look very good. On an average day, we make several changes, so content may appear/disappear at random.

#compile yourself

You can compile this yourself on Mac OS X, by installing [BasicTex](https://tug.org/mactex/morepackages.html), and adding the following packages using [TexLive](http://amaxwell.github.io/tlutility/): comment, tagging, bigfoot, bashful, ncctools, bidi. Similar software exists for the PC, although we don't provide download instructions here.

Then, compile in the root of the project folder with:

`xelatex -shell-escape -file-line-error -recorder quran-project.tex`

# license
[This repository](http://github.com/humblefoundation/quran-project), by the [Humble Foundation](http://www.humblefoundation.org) is licensed under the [Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License](http://creativecommons.org/licenses/by-nc-nd/4.0/).

