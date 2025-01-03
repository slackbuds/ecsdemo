package com.slackbuds.ecsdemo;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.auth.credentials.AwsCredentialsProvider;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;

@Configuration
public class AwsConf {

  @Bean
  public AwsCredentialsProvider awsCredentials() {
    return DefaultCredentialsProvider.create();
  }

  @Bean
  public DynamoDbClient dynamoDbClient(AwsCredentialsProvider awsCredentialsProvider) {
    return DynamoDbClient.builder()
        .credentialsProvider(awsCredentialsProvider)
        .build();
  }
}
