# TruncatedWiener
- This is the code for paper XXX

## Requirement
- MATLAB R2020a

## Notes
- __GaAs_Laser.xlsx__ is an open source degradation data set provided by [William Q. Meeker](https://www.wiley.com/en-us/Statistical+Methods+for+Reliability+Data,+2nd+Edition-p-9781118115459)
- EM_main.m is the main function for EM algorihtm, see technical details in Section 3.2 and Appendix A.1 of the paper
- guess_EM.m provides the educated initial values of EM algorthm, see technical details in Appendix A.2 of the paper
- ig_likeli.m calculates the log-likelihood function of Inverse Gaussian distribution
- partial_likeli_tau.m calculates the partial log-likehood function of $\tau$, see details in Equation (12) of the paper
- subplots.m is an open source code provided by [Pekka Kumpulainen](https://www.mathworks.com/matlabcentral/fileexchange/27991-tight_subplot-nh-nw-gap-marg_h-marg_w)
