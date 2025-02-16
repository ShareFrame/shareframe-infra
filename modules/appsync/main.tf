resource "aws_appsync_graphql_api" "appsync_api" {
  name                = "FrameAPI"
  authentication_type = "API_KEY"

  schema = <<EOF
  type Query {
    getProfile(did: String!): ProfileResponse
  }

  type Mutation {
    createUser(input: CreateUserInput!): UserResponse
  }

  type ProfileResponse {
    did: String!
    displayName: String!
    handle: String!
    description: String
    avatar: String
    banner: String
    followersCount: Int
    followsCount: Int
    postsCount: Int
    pinnedPost: PinnedPost
    indexedAt: String
    createdAt: String
    viewer: Viewer
    labels: [Labels]
  }

  type PinnedPost {
    uri: String
    cid: String
  }

  type Viewer {
    muted: Boolean!
    mutedByList: [Muter]
  }

  type Muter {
    uri: String
    cid: String
    name: String
    avatar: String
    listItemCount: Int
    labels: [Labels]
    viewer: Viewer
    indexedAt: String
  }

  type Labels {
    ver: Int
    src: String
    uri: String
    cid: String
    val: String
    neg: Boolean
    cts: String
    exp: String
    sig: String
  }

  type UserResponse {
    handle: String!
    did: String!
    accessJwt: String!
    refreshJwt: String!
  }

  input CreateUserInput {
    handle: String!
    email: String!
    password: String!
  }
  EOF
}


resource "aws_appsync_datasource" "get_profile_service" {
  api_id           = aws_appsync_graphql_api.appsync_api.id
  name             = "GetProfileService"
  type             = "AWS_LAMBDA"
  service_role_arn = "arn:aws:iam::585768148590:role/service-role/appsync-ds-lam-0tRfqFGYeaeH-profile-service"

  lambda_config {
    function_arn = "arn:aws:lambda:us-east-2:585768148590:function:profile-service"
  }
}

resource "aws_appsync_datasource" "user_creation_lambda" {
  api_id           = aws_appsync_graphql_api.appsync_api.id
  name             = "UserCreationLambda"
  type             = "AWS_LAMBDA"
  service_role_arn = "arn:aws:iam::585768148590:role/service-role/appsync-ds-lam-Ly0AOf9ns1XP-user-management-serv"

  lambda_config {
    function_arn = "arn:aws:lambda:us-east-2:585768148590:function:user-management-service"
  }
}

resource "aws_appsync_datasource" "posting_service" {
  api_id           = var.api_id
  name             = "ShareFrameFeedPostLambda"
  type             = "AWS_LAMBDA"
  service_role_arn = "arn:aws:iam::585768148590:role/service-role/appsync-ds-lam-CSbZFo4kpyes-posting-service"

  lambda_config {
    function_arn = "arn:aws:lambda:us-east-2:585768148590:function:posting-service"
  }
}

resource "aws_appsync_resolver" "get_profile_resolver" {
  api_id            = aws_appsync_graphql_api.appsync_api.id
  type              = "Query"
  field             = "getProfile"
  data_source       = aws_appsync_datasource.get_profile_service.name

  request_template  = <<EOF
  {
    "version": "2018-05-29",
    "operation": "Invoke",
    "payload": {
      "did": $util.toJson($context.arguments.did)
    }
  }
  EOF

  response_template = <<EOF
  #if($ctx.error)
    $util.error($ctx.error.message, "NotFound")
  #end
  $util.toJson($ctx.result)
  EOF
}

resource "aws_appsync_resolver" "create_user_resolver" {
  api_id            = aws_appsync_graphql_api.appsync_api.id
  type              = "Mutation"
  field             = "createUser"
  data_source       = aws_appsync_datasource.user_creation_lambda.name

  request_template  = <<EOF
  {
    "version": "2017-02-28",
    "operation": "Invoke",
    "payload": $util.toJson($context.arguments.input)
  }
  EOF

  response_template = <<EOF
  #if($ctx.result)
    {
      "handle": "$ctx.result.handle",
      "did": "$ctx.result.did",
      "accessJwt": "$ctx.result.accessJwt",
      "refreshJwt": "$ctx.result.refreshJwt"
    }
  #else
    $util.error("Invalid response from Lambda", "MappingTemplateError")
  #end
  EOF
}

resource "aws_appsync_resolver" "create_post_resolver" {
  api_id      = aws_appsync_graphql_api.appsync_api.id
  type        = "Mutation"
  field       = "createPost"
  data_source = aws_appsync_datasource.posting_service.name

  request_template = <<EOF
  {
    "version": "2018-05-29",
    "operation": "Invoke",
    "payload": {
      "authToken": "$ctx.args.input.authToken",
      "did": "$ctx.args.input.did",
      "post": {
        "text": "$ctx.args.input.post.text",
        "imageUris": $util.toJson($ctx.args.input.post.imageUris),
        "videoUris": $util.toJson($ctx.args.input.post.videoUris),
        "createdAt": "$ctx.args.input.post.createdAt",
        "nsid": "$ctx.args.input.post.nsid"
      }
    }
  }
  EOF

  response_template = <<EOF
  $util.toJson($context.result)
  EOF
}

