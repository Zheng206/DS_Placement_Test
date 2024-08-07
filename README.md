# Data Science Placement Assessment

This repository is created for the purpose of the data science placement assessment. The code folder contains both the R script (**R_script.R**) for all data analysis and the summarized data report in both `.qmd` and `.html` formats. For better readability, please refer to the HTML format version (**data_report.html**)!

Some key findings are summarized below:

## Death Toll from Natural Disasters in the 20th and 21st Centuries

![Death Toll](/figure/death_toll.png)

**Key Findings**:

-   In **1931**, the **flood** caused a significant number of deaths, far more than in any other year in the two centuries.
-   **Earthquakes**, **floods**, and **tropical cyclones** are three types of disasters that have been seen more often in the past two centuries compared to other types. Among these three, **earthquakes** are the most common.
-   **Tropical cyclones** were seen more often from the **1950s to the 1980s**.

## Gradient Descent Algorithm

![gradient descent](/figure/gradient_descent.png)

**Key Findings**:

-   If the **learning rate is too large**, each update step can move far from its current position, pushing b further away and causing it to **diverge** to very large values. This can make the loss function increase rather than decrease or cause b to **oscillate around the minimum**.
-   Different values of n are sensitive to different learning rates: as **n becomes larger**, the **learning rate needs to be smaller**, or the algorithm will diverge and fail.