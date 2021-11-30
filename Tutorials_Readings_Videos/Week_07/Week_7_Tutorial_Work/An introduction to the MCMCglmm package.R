############################################################################
###                Meta-analysis for biologists using MCMCglmm:          ###
###                   An introduction to the MCMCglmm package            ###
###                                                                      ###
###                            MICHAEL ZARGARI                           ###
###                           02-November-2021                           ###
###                   CONTACT EMAIL: S2253374@ED.AC.UK                   ###
###                                                                      ###
###         https://ourcodingclub.github.io/tutorials/model-design/      ###
############################################################################

setwd("~/Desktop/EDS (Environmental Data Science) Course/course-repository-mzargari/Tutorials_Readings_Videos/Week 7")

# Load packages

library("MCMCglmm") # for meta-analysis
library("dplyr") # for data manipulation

migrationdata <- read.csv("migration_metadata.csv", header = T) # import dataset
View(migrationdata) # have a look at the dataset. Check out the Predictor variable. There are two, time and temperature.

migrationdata %>%
  filter(Predictor == "year") -> migrationtime # this reduces the dataset to one predictor variable, time.

plot(migrationtime$Slope, I(1/migrationtime$SE)) # this makes the funnel plot of slope (rate of change in days/year) and precision (1/SE)

plot(migrationtime$Slope, I(1/migrationtime$SE), xlim = c(-2,2), ylim = c(0, 60))

randomtest <- MCMCglmm(Slope ~ 1, random = ~Species + Location + Study, data = migrationtime)
summary(randomtest)

# Plot the posterior distribution as a histogram to check for significance and whether it's been well estimated or not
# Variance cannot be zero, and therefore if the mean value is pushed up against zero your effect is not significant
# The larger the spread of the histogram, the less well estimated the distribution is.

par(mfrow = c(1,3))

hist(mcmc(randomtest$VCV)[,"Study"])
hist(mcmc(randomtest$VCV)[,"Location"])
hist(mcmc(randomtest$VCV)[,"Species"])

par(mfrow=c(1,1)) # Reset the plot panel back to single plots

plot(randomtest$Sol)

plot(randomtest$VCV)

# Understanding parameter expanded priors and measurement error ----

a <- 1000
prior1 <- list(R = list(V = diag(1), nu = 0.002),
               G = list(G1 = list(V = diag(1), nu = 1, alpha.mu = 0, alpha.V = diag(1)*a),
                        G1 = list(V = diag(1), nu = 1, alpha.mu = 0, alpha.V = diag(1)*a),
                        G1 = list(V = diag(1), nu = 1, alpha.mu = 0, alpha.V = diag(1)*a)))

randomprior <- MCMCglmm(Slope ~ 1, random = ~Species + Location + Study, 
                        data = migrationtime, prior = prior1, nitt = 60000)

summary(randomprior)

plot(randomprior$VCV)

prior2 <- list(R = list(V = diag(1), nu = 0.002),
               G = list(G1 = list(V = diag(1), nu = 1, alpha.mu = 0, alpha.V = diag(1)*a),
                        G1 = list(V = diag(1), nu = 1, alpha.mu = 0, alpha.V = diag(1)*a),
                        G1 = list(V = diag(1), nu = 1, alpha.mu = 0, alpha.V = diag(1)*a),
                        G1 = list(V = diag(1), fix = 1)))

randomerror2 <- MCMCglmm(Slope ~ 1, random = ~Species + Location + Study + idh(SE):units, 
                         data = migrationtime, prior = prior2, nitt = 60000)

plot(randomerror2$VCV)

xsim <- simulate(randomerror2) # reruns 100 new models, based around the same variance/covariance structures but with simulated data.

plot(migrationtime$Slope, I(1/migrationtime$SE))
points(xsim, I(1/migrationtime$SE), col = "red") # here you can plot the data from both your simulated and real datasets and compare them

prior3 <- list(R = list(V = diag(1), nu = 0.002),
               G = list(G1 = list(V = diag(1), nu = 1, alpha.mu = 0, alpha.V = diag(1)*a),
                        G1 = list(V = diag(1), nu = 1, alpha.mu = 0, alpha.V = diag(1)*a),
                        G1 = list(V = diag(1), nu = 1, alpha.mu = 0, alpha.V = diag(1)*a),
                        G1 = list(V = diag(1), nu = 1, alpha.mu = 0, alpha.V = diag(1)*a)))

randomerror3 <- MCMCglmm(Slope ~ 1, random = ~Species + Location + Study + idh(SE):units, 
                         data = migrationtime, prior = prior3, nitt = 60000)

xsim <- simulate(randomerror3)

plot(migrationtime$Slope, I(1/migrationtime$SE))
points(xsim, I(1/migrationtime$SE), col = "red") # here you can plot the data from both your simulated and real datasets and compare them

xsim <- simulate(randomerror3, 1000) # 1000 represents the number of simulations, and for some reason needs to be higher than the default to work in this case
hist(apply(xsim, 2, max), breaks = 30) # plot your simulation data

abline(v = max(migration$Slope), col = "red") # check to see whether the max value of your real data falls within this histogram.

# Fixed effects ----
# I have never had to change the priors for a fixed effect, but this would be worth some research for your own projects
xfixedtest <- MCMCglmm(Slope ~ Migration_distance + Continent, random = ~Species + Location + Study + idh(SE):units, prior = prior3,data = migrationtime, nitt = 60000)

fixedtest <- MCMCglmm(Slope ~ Migration_distance + Continent, random = ~Species + Location + Study + idh(SE):units,
                      data = migrationtime, prior = prior3, pr = TRUE, nitt = 60000)

posteriormode <- apply(fixedtest$Sol, 2, mode)

names(posteriormode) # identify which posterior modes belong to Species
posteriormode[9:416] # there are a lot of species in this analysis!

sort(posteriormode[9:416])

# Calculating 95% Credible Intervals
HPDinterval(mcmc(fixedtest$Sol[,"(Intercept)"]))

mean(mcmc(fixedtest$Sol[,"(Intercept)"]) + fixedtest$Sol[,"Migration_distanceshort"] + fixedtest$Sol[,"ContinentEurope"])

HPDinterval(mcmc(fixedtest$Sol[,"(Intercept)"]) + fixedtest$Sol[,"Migration_distanceshort"] + fixedtest$Sol[,"ContinentEurope"])

# (Co)variance structures
levels(migrationtime$Response_variable)

prior4 <- list(R = list(V = diag(3), nu = 0.002),
               G = list(G1 = list(V = diag(1), nu = 1, alpha.mu = 0, alpha.V = diag(1)*a),
                        G1 = list(V = diag(1), nu = 1, alpha.mu = 0, alpha.V = diag(1)*a),
                        G1 = list(V = diag(1), nu = 1, alpha.mu = 0, alpha.V = diag(1)*a),
                        G1 = list(V = diag(1), nu = 1, alpha.mu = 0, alpha.V = diag(1)*a)))

fixedtest <- MCMCglmm(Slope ~ Migration_distance + Continent, random = ~Species + Location + Study + idh(SE):units,
                      data = migrationtime, rcov = ~idh(Response_variable):units, prior = prior4, pr = TRUE, nitt = 60000)

summary(fixedtest)

G1 = list(V = diag(3), nu = 3, alpha.mu = rep(0,3), alpha.V = diag(3)*a),

