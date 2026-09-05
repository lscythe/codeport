use codeport_github::pagination::next_page;

#[test]
fn parses_github_link_header_for_next_page() {
    let header = Some(
        r#"<https://api.github.com/user/repos?page=2>; rel="next", <https://api.github.com/user/repos?page=5>; rel="last""#.to_string(),
    );
    assert_eq!(next_page(&header), Some(2));
}

#[test]
fn returns_none_when_no_next_link() {
    let header = Some(
        r#"<https://api.github.com/user/repos?page=5>; rel="last""#.to_string(),
    );
    assert_eq!(next_page(&header), None);
}

#[test]
fn returns_none_for_missing_header() {
    assert_eq!(next_page(&None), None);
}
