# TruncatedWiener
- This is the code for the paper :
_Yan, B., Wang, H., & Ma, X. (2023). [Modeling left-truncated degradation data using random drift-diffusion Wiener processes](https://www.tandfonline.com/doi/abs/10.1080/16843703.2023.2187011). Quality Technology & Quantitative Management, 1-24._

## Requirement
- MATLAB R2020a

## Notes
- __GaAs_Laser.xlsx__ is an open-source laser degradation data set provided by [William Q. Meeker](https://www.wiley.com/en-us/Statistical+Methods+for+Reliability+Data,+2nd+Edition-p-9781118115459)
- __EM_main.m__ is the main function for the EM algorithm. See technical details in Section 3.2 and Supplementary S.1 of the paper
- __guess_EM.m__ provides the educated initial values of model parameters in the EM algorithm. See technical details in Supplementary S.1 of the paper
- __ig_likeli.m__ calculates the log-likelihood function of the Inverse Gaussian distribution
- __partial_likeli_tau.m__ calculates the partial log-likelihood function of the truncation time parameter $\tau$. See details in Equation (12) of the paper
- __subplots.m__ fills the figure with axes subplots with easily adjustable margins and gaps between the axes. This is an open-source code provided by [Pekka Kumpulainen](https://www.mathworks.com/matlabcentral/fileexchange/27991-tight_subplot-nh-nw-gap-marg_h-marg_w)
- Email me if you have any questions: yanbingxin124@163.com
