# multinomial logistic regression

# adding a combined fatal/serious binary column 
df_recoded <- df_recoded %>%
  mutate(severity_combined = ifelse(accident_severity %in% 
                                      c("Serious", "Fatal"),
                                    "Fatal/Serious", "Slight"))

# creating dataframe for modelling
df_lr3 <- df_recoded %>%
  filter(accident_year.x == 2023, !is.na(road_surface_conditions), !is.na(urban_or_rural_area)) %>%
  mutate(
    severity_combined = factor(severity_combined, levels = c("Slight", "Fatal/Serious")),
    road_surface_conditions = factor(road_surface_conditions),
    urban_or_rural_area = factor(urban_or_rural_area),
    binaryseverity = as.numeric(severity_combined == "Fatal/Serious")  # Binary target
  )

# 70/30 train/test split
train_size <- 0.7
df_train <- df_lr3[1:(train_size * nrow(df_lr3)), ]
df_test <- df_lr3[(nrow(df_train) + 1):nrow(df_lr3), ]

# Logistic regression
combined_model <- glm(
  binaryseverity ~ urban_or_rural_area + road_surface_conditions,
  family = binomial(link = "logit"),
  data = df_train
)

# Predict probabilities on test data
probabilities_combined <- predict(combined_model, newdata = df_test, type = "response")

# Convert probabilities to class predictions
threshold <- 0.5  # Default threshold
predictions_combined <- ifelse(probabilities_combined > threshold, 1, 0)

# Evaluate model performance
classification_error <- mean(predictions_combined != df_test$binaryseverity)
print(paste("Accuracy:", 1 - classification_error))


confusion <- confusionMatrix(
  factor(predictions_combined),
  factor(df_test$binaryseverity)
)
print(confusion)

# accuracy is 71%, 100% sensitivity and 0% specificity




#re-training on oversampled data:
df_train$binaryseverity <- as.factor(df_train$binaryseverity)

oversampled_multi_data <- upSample(
  x = df_train[, setdiff(names(df_train), "binaryseverity")],
  y = df_train$binaryseverity,
  yname = "binaryseverity"
)

# Logistic regression after over-sampling
oversampled_multi_model <- glm(binaryseverity ~ urban_or_rural_area+road_surface_conditions,
                               family = binomial(link = "logit"),
                               data = oversampled_multi_data)

multi_probabilities_oversamp <- predict(
  oversampled_multi_model,	
  newdata=df_test,	
  type='response'	
)	
print(multi_probabilities_oversamp)

multi_predictions_oversamp <- ifelse(
  multi_probabilities_oversamp>0.5,	
  1,	
  0	
)	
print(multi_predictions_oversamp)

df_test$binaryseverity <- df_test$severity_combined == 'Fatal/Serious'
df_test$binaryseverity <- df_test$binaryseverity * 1 

multi_classification_error <- mean(
  multi_predictions_oversamp != df_test$binaryseverity
)	
print(paste('Accuracy',1-multi_classification_error))

# confusion matrix from caret package 
confusion_oversamp <- confusionMatrix(
  factor(multi_predictions_oversamp),
  factor(df_test$binaryseverity)
)
print(confusion_oversamp)

# accuracy 53.3%, sensitivity 50.1%, specificity 61.4%






# retry with under-sampling the majority class

undersampled_multi_data <- downSample(
  x = df_train[, setdiff(names(df_train), "binaryseverity")],
  y = df_train$binaryseverity,
  yname = "binaryseverity"
)

# Logistic regression after under-sampling
undersampled_multi_model <- glm(binaryseverity ~ urban_or_rural_area,
                                family = binomial(link = "logit"),
                                data = undersampled_multi_data)


multi_probabilities_undersamp <- predict(
  undersampled_multi_model,	
  newdata=df_test,	
  type='response'	
)	

print(multi_probabilities_undersamp)

multi_predictions_undersamp <- ifelse(
 multi_probabilities_undersamp>0.5,	
  1,	
  0	
)	
print(multi_predictions_undersamp)

df_test$binaryseverity <- df_test$severity_combined == 'Fatal/Serious'
df_test$binaryseverity <- df_test$binaryseverity * 1 

multi_classification_error <- mean(
  multi_predictions_undersamp != df_test$binaryseverity
)	
print(paste('Accuracy',1-multi_classification_error))

# confusion matrix from caret package 
confusion_undersamp <- confusionMatrix(
  factor(multi_predictions_undersamp),
  factor(df_test$binaryseverity)
)
print(confusion_undersamp)

# accuracy 53.4%, sensitivity 50.1%, specificity 61.4%
