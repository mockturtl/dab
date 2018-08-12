import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;

main(List<String> arguments) async {
  load();

//  await github();
  await gitlab();
}

const github_v4 = 'https://api.github.com/graphql';
const gitlab_v4_create =
    'https://gitlab.com/api/v4/projects?name=xyz'; // MUST be percent-encoded

const gitlab_v4_delete = 'https://gitlab.com/api/v4/projects/mockturtl%2Fxyz';

const login = {
  'query': '''{
  viewer {
    login
  }
}'''
};

const response = '''{
  "id": 7917571,
  "description": null,
  "name": "efgh",
  "name_with_namespace": "tm / efgh",
  "path": "efgh",
  "path_with_namespace": "mockturtl/efgh",
  "created_at": "2018-08-13T04:01:09.888Z",
  "default_branch": null,
  "tag_list": [],
  "ssh_url_to_repo": "git@gitlab.com:mockturtl/efgh.git",
  "http_url_to_repo": "https://gitlab.com/mockturtl/efgh.git",
  "web_url": "https://gitlab.com/mockturtl/efgh",
  "readme_url": null,
  "avatar_url": null,
  "star_count": 0,
  "forks_count": 0,
  "last_activity_at": "2018-08-13T04:01:09.888Z",
  "namespace": {
    "id": 1453712,
    "name": "mockturtl",
    "path": "mockturtl",
    "kind": "user",
    "full_path": "mockturtl",
    "parent_id": null
  },
  "_links": {
    "self": "https://gitlab.com/api/v4/projects/7917571",
    "issues": "https://gitlab.com/api/v4/projects/7917571/issues",
    "merge_requests": "https://gitlab.com/api/v4/projects/7917571/merge_requests",
    "repo_branches": "https://gitlab.com/api/v4/projects/7917571/repository/branches",
    "labels": "https://gitlab.com/api/v4/projects/7917571/labels",
    "events": "https://gitlab.com/api/v4/projects/7917571/events",
    "members": "https://gitlab.com/api/v4/projects/7917571/members"
  },
  "archived": false,
  "visibility": "private",
  "owner": {
    "id": 1216744,
    "name": "tm",
    "username": "mockturtl",
    "state": "active",
    "avatar_url": "https://secure.gravatar.com/avatar/5bdf009704d1585ea463a245058081da?s=80&d=identicon",
    "web_url": "https://gitlab.com/mockturtl"
  },
  "resolve_outdated_diff_discussions": false,
  "container_registry_enabled": true,
  "issues_enabled": true,
  "merge_requests_enabled": true,
  "wiki_enabled": true,
  "jobs_enabled": true,
  "snippets_enabled": true,
  "shared_runners_enabled": true,
  "lfs_enabled": true,
  "creator_id": 1216744,
  "import_status": "none",
  "import_error": null,
  "open_issues_count": 0,
  "runners_token": "ZdqQq4SS6-B46y-CUDqu",
  "public_jobs": true,
  "ci_config_path": null,
  "shared_with_groups": [],
  "only_allow_merge_if_pipeline_succeeds": false,
  "request_access_enabled": false,
  "only_allow_merge_if_all_discussions_are_resolved": false,
  "printing_merge_request_link_enabled": true,
  "merge_method": "merge",
  "approvals_before_merge": 0,
  "mirror": false
}
''';

Future github() async {
  final token = env['github_token'];
  final auth = {HttpHeaders.authorizationHeader: 'bearer $token'};
  final res = await http.post(github_v4,
      headers: auth, body: IssuesRequest().present());
  final List body =
      jsonDecode(res.body)['data']['repository']['issues']['edges'];
  final nodes = body.cast<Map<String, dynamic>>();
  final issues = nodes.map((e) => e['node']).cast<Map<String, dynamic>>();
  print(issues);
  final data = issues.map((e) => Issue.fromJson(e));
  data.forEach(print);
}

Future gitlab() async {
  final token = env['gitlab_token'];
  final auth = {"Private-Token": token};

  // note http verbs take different endpoints
  final res = await http.delete(
    gitlab_v4_delete,
    headers: auth,
  );
  final Map<String, dynamic> body = jsonDecode(res?.body);
  print('${res.statusCode} $body');
}

class Issue {
  final String title;
  final Uri url;
  final Set<String> labels;

  factory Issue.fromJson(Map<String, dynamic> json) => Issue._internal(
      json['title'],
      Uri.parse(json['url']),
      json['labels']['edges'].map((ob) => ob['node']['name']).cast<String>());

  Issue._internal(this.title, this.url, Iterable labels)
      : labels = labels.toSet();

  @override
  String toString() => 'Issue title=$title, url=$url, labels=$labels';
}

class IssuesRequest {
  final String owner, repo;
  final IssueState state;

  IssuesRequest(
      [this.owner = 'mockturtl',
      this.repo = 'dotenv',
      this.state = IssueState.open]);

  Map get sample => {
        'query': '''{
  repository(owner:"$owner", name:"$repo") {
    issues(last:20, states:${IssueState.open}) {
      edges {
        node {
          title
          url
          labels(first:5) {
            edges {
              node {
                name
              }
            }
          }
        }
      }
    }
  }
}'''
      };

  String present() => jsonEncode(sample);
}

class IssueState {
  static const open = IssueState._('OPEN');
  static const closed = IssueState._('CLOSED');

  final String value;

  const IssueState._(this.value);

  @override
  String toString() => value;
}
