Cord Ministries Donation Income Investigation Tool
========================================================
author: Ken Wade
date: 21 Nov 2016
autosize: true
Week 4 Homework: **Peer-graded Assignment: Course Project: Shiny Application and Reproducible Pitch**

A real-world Exploratory Data Analysis problem to solve that is perfect for this assignment.

Introduction
========================================================

**The Cord Ministries Donation Income Investigation Tool** is my submission for the Week 4 Homework for the JHU Developing Data Products course.

The goal was to solve a real-world work problem as my selected homework assignment.

The purpose of investigating actual year-to-date donations for our foundation is to understand the donation amount distribution pattern and to guide the selection of a fair PerCent Fee and PerCent Fee Limit on each donation to cover the overhead cost of Cord Ministries. The PerCent Fee Limit puts a rational limit on fees collected for the few very large donations.

Up-to-date Donation Data is extracted from the accounting system and processed to remove donor information. This information is uploaded to GitHub for universal access. Each donation record in this file contains a donation date, amount, and project designation.



The most recent GitHub data contains: **1051** donations, covering the time period of **2016-01-04** to **2016-11-07**. The donations range from **US\$10.00** to **US\$30,000.00** with an average of **US\$444.11**.


Directions for Use:
========================================================
There are two parts of the **The Cord Ministries Donation Income Investigation Tool** application display; the left **Side Bar** that shows information about the donation data itself and the **Main Panel** to the right that shows the Exploratory Data Analysis graphic of interest.

Within the Main Panel are two tabs; **Donation Overview** and **Income Calculation**

**Donation Overview** Tab:

This tab shows a histogram graphic of the donation amounts within the range selected by the slider on the bottom. The slider allows zooming in on a donation amount range of interest.

**Income Calculation** Tab:

This tab shows a display of hypothetical Cord Ministries incomes for the slider-selected PerCent Fees and PerCent Fee Limits. The PerCent Fee is simply a percent of the donation. The PerCent Fee Limit is the highest fee that could be taken for a large donation. Ridiculously large fees are unreasonable. The colors of the graphic are controlled by the Income Target selected.

Income Calculation Tab:
========================================================
**The Cord Ministries Income From Donations** graphic displays the hypothetical Cord Ministries income over the selected range of PerCent Fees and a PerCent Fee Limits.

The Income Target is selected to show all the PerCent Fee and PerCent Fee Limit combinations that would generate the desired income. Combinations that generate less income are color-coded red; combinations generating more income are color-coded blue. An animated cursor shows the income at the exact combination.

As the required calculation may take several moments the **Submit** must be pressed to update the graphic.

Reference
========================================================

* Actual Year-to-Date Family Connection Foundation Donations

* [Cord Ministries Web Page](http://www.cordmin.com/)

* [Family Connection Foundation Web Page](http://www.thaiconnections.org/fcf)

