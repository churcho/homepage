import * as React from "react";
import { Menu } from "semantic-ui-react";
import { Link, withRouter, RouteComponentProps } from "react-router-dom";
import { connect } from "react-redux";
import { compose } from "redux";

interface _Props {
  activeItem: String;
  destroySession?: () => void;
  sessionAuthenticated?: Boolean;
  csrfToken?: String;
}

type Props = _Props & Partial<RouteComponentProps<any>>;

interface State {
  activeItem: String;
}

class _MainNav extends React.Component<Props, State> {
  constructor(props) {
    super(props);
    this.state = { activeItem: props.activeItem };
  }

  render() {
    const { activeItem } = this.state;

    return (
      <Menu>
        <Menu.Menu position="left">
          <Link to="/">
            <Menu.Item name={"home"} active={activeItem === "home"} />
          </Link>

          <Link to="/ijust">
            <Menu.Item name={"ijust"} active={activeItem === "ijust"} />
          </Link>

          <Link to="/coffeemaker">
            <Menu.Item
              name={"coffeemaker"}
              active={activeItem === "coffeemaker"}
            />
          </Link>

          <Link to="/resume">
            <Menu.Item name={"resume"} active={activeItem === "resume"} />
          </Link>

          <Link to="/twitch">
            <Menu.Item name={"twitch"} active={activeItem === "twitch"} />
          </Link>
        </Menu.Menu>

        <Menu.Menu position="right">
          <Link to="/settings">
            <Menu.Item name={"settings"} active={activeItem === "settings"} />
          </Link>
          {this.renderLoginOrLogout()}
        </Menu.Menu>
      </Menu>
    );
  }

  renderLoginOrLogout = () => {
    const { activeItem } = this.state;

    if (this.props.sessionAuthenticated) {
      return (
        <Menu.Item
          name={"logout"}
          active={activeItem === "logout"}
          onClick={this.logout}
        />
      );
    } else {
      return <Menu.Item name={"login"} active={false} onClick={this.login} />;
    }
  };

  logout = () => {
    fetch("/api/logout", {
      method: "POST",
      credentials: "same-origin"
    })
      .then(response => {
        if (response.ok) {
          this.props.destroySession();
          this.props.history.push("/login");
        } else {
          return response.json();
        }
      })
      .then(response => {
        if (response && response.messages) {
          console.error(response.messages);
        }
      });
  };

  login = () => {
    this.props.history.push("/");
  };
}

const mapStateToProps = state => ({
  csrfToken: state.csrfToken,
  sessionAuthenticated: state.session.established
});

const mapDispatchToProps = dispatch => ({
  destroySession: () =>
    dispatch({ type: "SET_SESSION_ESTABLISHED", established: false })
});

export const MainNav = compose(connect(mapStateToProps, mapDispatchToProps))(
  _MainNav
);
