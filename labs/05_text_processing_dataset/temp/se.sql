--
--  Author: Hari Sekhon
--  Date: 2020-01-01 15:38:58 +0000 (Wed, 01 Jan 2020)
--
--  vim:ts=4:sts=4:sw=4:et:filetype=sql
--
--  https://github.com/HariSekhon/SQL-scripts
--
--  License: see accompanying Hari Sekhon LICENSE file
--
--  If you're using my code you're welcome to connect with me on LinkedIn
--  and optionally send me feedback to help improve or steer this or other code I publish
--
--  https://www.linkedin.com/in/HariSekhon
--

-- replace <MY_BUCKET> and <MY_ACCOUNT_NUMBER> on last line

CREATE EXTERNAL TABLE cloudtrail_logs (
    eventVersion STRING,
    userIdentity STRUCT<
        type: STRING,
        principalId: STRING,
        arn: STRING,
        accountId: STRING,
        invokedBy: STRING,
        accessKeyId: STRING,
        userName: STRING,
        sessionContext: STRUCT<
            attributes: STRUCT<
                mfaAuthenticated: STRING,
                creationDate: STRING>,
            sessionIssuer: STRUCT<
                type: STRING,
                principalId: STRING,
                arn: STRING,
                accountId: STRING,
                userName: STRING>>>,
    eventTime STRING,
    eventSource STRING,
    eventName STRING,
    awsRegion STRING,
    sourceIpAddress STRING,
    userAgent STRING,
    errorCode STRING,
    errorMessage STRING,
    requestParameters STRING,
    responseElements STRING,
    additionalEventData STRING,
    requestId STRING,
    eventId STRING,
    resources ARRAY<STRUCT<
        arn: STRING,
        accountId: STRING,
        type: STRING>>,
    eventType STRING,
    apiVersion STRING,
    readOnly STRING,
    recipientAccountId STRING,
    serviceEventDetails STRING,
    sharedEventID STRING,
    vpcEndpointId STRING
)
COMMENT 'CloudTrail table for <MY_BUCKET> bucket'
ROW FORMAT SERDE 'com.amazon.emr.hive.serde.CloudTrailSerde'
STORED AS INPUTFORMAT 'com.amazon.emr.cloudtrail.CloudTrailInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION 's3://<MY_BUCKET>/AWSLogs/<MY_ACCOUNT_NUMBER>/'
TBLPROPERTIES ('classification'='cloudtrail');
--
--  author: hari sekhon
--  date: 2020-01-01 15:38:58 +0000 (wed, 01 jan 2020)
--
--  vim:ts=4:sts=4:sw=4:et:filetype=sql
--
--  https://github.com/harisekhon/sql-scripts
--
--  license: see accompanying hari sekhon license file
--
--  if you're using my code you're welcome to connect with me on linkedin
--  and optionally send me feedback to help improve or steer this or other code i publish
--
--  https://www.linkedin.com/in/harisekhon
--

-- replace <my_bucket> and <my_account_number> on last line

create external table cloudtrail_logs (
    eventversion string,
    useridentity struct<
        type: string,
        principalid: string,
        arn: string,
        accountid: string,
        invokedby: string,
        accesskeyid: string,
        username: string,
        sessioncontext: struct<
            attributes: struct<
                mfaauthenticated: string,
                creationdate: string>,
            sessionissuer: struct<
                type: string,
                principalid: string,
                arn: string,
                accountid: string,
                username: string>>>,
    eventtime string,
    eventsource string,
    eventname string,
    awsregion string,
    sourceipaddress string,
    useragent string,
    errorcode string,
    errormessage string,
    requestparameters string,
    responseelements string,
    additionaleventdata string,
    requestid string,
    eventid string,
    resources array<struct<
        arn: string,
        accountid: string,
        type: string>>,
    eventtype string,
    apiversion string,
    readonly string,
    recipientaccountid string,
    serviceeventdetails string,
    sharedeventid string,
    vpcendpointid string
)
comment 'cloudtrail table for <my_bucket> bucket'
row format serde 'com.amazon.emr.hive.serde.cloudtrailserde'
stored as inputformat 'com.amazon.emr.cloudtrail.cloudtrailinputformat'
outputformat 'org.apache.hadoop.hive.ql.io.hiveignorekeytextoutputformat'
location 's3://<my_bucket>/awslogs/<my_account_number>/'
tblproperties ('classification'='cloudtrail');
