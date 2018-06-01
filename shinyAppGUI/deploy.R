install.packages('rsconnect')
rsconnect::setAccountInfo(name='ankurvinekar',
                          token='68F47E42DB616AB11EB27C0A9D8FE38D',
                          secret='1ePJe2WY6FJBEWO1ci+QUxmEJZ1KtrpkgOrm3wg3')

library(rsconnect)
rsconnect::deployApp()