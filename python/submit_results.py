#!/usr/bin/env python3

import argparse
import json
import sys

try:
    import requests
except ImportError:
    import pip
    pip.main(['install', 'requests'])

    import requests

BASE_URL = 'https://screen-web.herokuapp.com'

def parse_results(filename):
    '''
    Consume a screen results file and return a dictionary describing it.
    '''
    d = {}
    with open(filename, 'r') as f:
        contents = f.read()
        print("Parsing JSON: ", contents)
        results = json.loads(contents)
        for obj in results:
            d.update(obj)
    return d

def owner_repo(val):
    """ Validate value to make sure it has a slash """
    owner, _, repo = val.partition('/')
    if not owner or not repo:
        raise argparse.ArgumentTypeError(
            'please supply value in format OWNER/REPO',
        )
    return val

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Submit results to DynamoDB')
    parser.add_argument('results', type=str)
    parser.add_argument('-c', '--commit', type=str, required=True,
                        help='Commit that these results are associated with.',
                        dest='commit')
    parser.add_argument('-r', '--owner-repo', type=owner_repo, required=True,
                        help='Repository identifier (in format OWNER/REPO) '
                        'for which the analysis was performed')
    parser.add_argument('-k', '--api-key', type=str, required=True,
                        help='API key for the project')
    args = parser.parse_args()

    report = parse_results(args.results)

    res = requests.put(
        BASE_URL + '/{owner_repo}/publish/{commit}'.format(
            owner_repo=args.owner_repo,
            commit=args.commit,
        ),
        params={'key': args.api_key},
        json=report,
    )
    # response should always be json, unless network is dead
    print(res.json())
    if not res.ok:  # .ok is False for 4xx and 5xx codes
        # notify failure status
        sys.exit(1)
