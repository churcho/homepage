import * as React from "react";
import gql from "graphql-tag";
import { Button, Header, Table } from "semantic-ui-react";
import { css, StyleSheet } from "aphrodite";
import { format, distanceInWordsToNow } from "date-fns";

import { QueryLoader } from "@utils/QueryLoader";
import { Constants } from "@utils/Constants";

const QUERY = gql`
  query GetIjustEventOccurrences($eventId: ID!, $offset: Int!) {
    getIjustEventOccurrences(eventId: $eventId, offset: $offset) {
      id
      insertedAt
    }
  }
`;

const styles = StyleSheet.create({
  relativeDateSpacer: {
    marginLeft: "10px"
  }
});

interface State {
  offset: number;
}

interface Props {
  eventId: string;
}

export class IjustEventOccurrences extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { offset: 0 };
  }

  render() {
    const { offset } = this.state;
    const { eventId } = this.props;
    return (
      <div>
        <Header>Occurrences</Header>
        <QueryLoader
          query={QUERY}
          variables={{ eventId, offset }}
          component={({ data, fetchMore }) => {
            const occurrences = data.getIjustEventOccurrences;
            return (
              <div>
                <Table basic="very">
                  <Table.Body>{occurrences.map(renderOccurrence)}</Table.Body>
                </Table>
                <Button
                  onClick={() => {
                    fetchMore({
                      variables: { offset: occurrences.length },
                      updateQuery: (prev, { fetchMoreResult }) => {
                        if (!fetchMoreResult) {
                          return prev;
                        }
                        return Object.assign({}, prev, {
                          getIjustEventOccurrences: [
                            ...prev.getIjustEventOccurrences,
                            ...fetchMoreResult.getIjustEventOccurrences
                          ]
                        });
                      }
                    });
                  }}
                >
                  Load more
                </Button>
              </div>
            );
          }}
        />
      </div>
    );
  }
}

const renderOccurrence = occurrence => (
  <Table.Row key={occurrence.id}>
    <Table.Cell>
      {format(occurrence.insertedAt, Constants.dateTimeFormat)}
      <span className={css(styles.relativeDateSpacer)}>
        ({distanceInWordsToNow(occurrence.insertedAt)} ago)
      </span>
    </Table.Cell>
  </Table.Row>
);
