# PIVOTAL CHANGELOG

This tiny tool generates changelog for each iteration in Agile methodology

## Getting Started

## Installing

  There are 2 ways:

    - Using `gem install pivotal_changelog`
    - Clone the project `git clone git@github.com:duykhoa/pivotal_changelog.git`

  To generate the changelog, follows this command

  ```
    ruby -Ilib bin/pivotal_changelog -c ~/.pivotal_changelog.yml
  ```

  The config file (~/.pivotal_changelog.yml) follows the format:

  ```yml
    ---

    subject: "Default Subject line"
    from_email: "duykhoa12t@gmail.com"
    from_name: Kevin Tran
    send_email_passwd: <PASSWORD>
    to_emails:
      - "duykhoa12t+test@gmail.com"
      - "duykhoa12t+new@gmail.com"
    project_token: <PIVOTAL TOKEN>
    project_id: <PIVOTAL PROJECT_ID>
    sprint_duration: 7
  ```

## Built with

  - [Tracker Api](https://github.com/dashofcode/tracker_api)
  - [Minitest](https://github.com/seattlerb/minitest)
  - [FFaker](https://github.com/ffaker/ffaker/)

## Contributing

  All contributions are wellcome!

## License

  This project is licensed under the MIT License - see the LICENSE.md](https://github.com/duykhoa/pivotal_changelog/blob/master/LICENSE.md) file for details
