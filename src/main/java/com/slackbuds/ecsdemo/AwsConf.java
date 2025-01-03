package com.slackbuds.ecsdemo;

import org.apache.logging.log4j.util.Strings;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.auth.credentials.AwsCredentialsProvider;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;

@Configuration
public class AwsConf {

  @Bean
  public AwsCredentialsProvider awsCredentials() {
    return DefaultCredentialsProvider.create();
  }

  @Bean
  public DynamoDbClient dynamoDbClient(AwsCredentialsProvider awsCredentialsProvider) {
    var region = System.getenv("AWS_REGION");
    return DynamoDbClient.builder()
        .region(Strings.isBlank(region) ? Region.US_WEST_2 : Region.of(region))
        .credentialsProvider(awsCredentialsProvider)
        .build();
  }
}
