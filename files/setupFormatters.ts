/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
import {
  createDurationFormatter,
  createD3NumberFormatter,
  getNumberFormatter,
  getNumberFormatterRegistry,
  NumberFormats,
  getTimeFormatterRegistry,
  SMART_DATE_ID,
  SMART_DATE_DETAILED_ID,
  SMART_DATE_VERBOSE_ID,
  createSmartDateFormatter,
  createSmartDateVerboseFormatter,
  createSmartDateDetailedFormatter,
  createMemoryFormatter,
} from '@superset-ui/core';
import { FormatLocaleDefinition } from 'd3-format';
import { TimeLocaleDefinition } from 'd3-time-format';

/**
 * Overloaded signatures so that setupFormatters can be called with or without parameters.
 */
export default function setupFormatters(): void;
export default function setupFormatters(
  d3NumberFormat: Partial<FormatLocaleDefinition>,
  d3TimeFormat: Partial<TimeLocaleDefinition>,
): void;
export default function setupFormatters(
  d3NumberFormat?: Partial<FormatLocaleDefinition>,
  d3TimeFormat?: Partial<TimeLocaleDefinition>,
) {
  const numberFormatterRegistry = getNumberFormatterRegistry();
  // If a d3NumberFormat was provided and the registry supports setting it, use it.
  if (d3NumberFormat && typeof numberFormatterRegistry.setD3Format === 'function') {
    numberFormatterRegistry.setD3Format(d3NumberFormat);
  }
  numberFormatterRegistry
    // Legacy registrations for various format strings.
    .registerValue(',0', getNumberFormatter(',.4~f'))
    .registerValue('null', getNumberFormatter(',.4~f'))
    .registerValue('%', getNumberFormatter('.0%'))
    .registerValue('.', getNumberFormatter('.4~f'))
    .registerValue(',f', getNumberFormatter(',d'))
    .registerValue(',r', getNumberFormatter(',.4f'))
    .registerValue('0f', getNumberFormatter(',d'))
    .registerValue(',#', getNumberFormatter(',.4~f'))
    .registerValue('$,f', getNumberFormatter('$,d'))
    .registerValue('0%', getNumberFormatter('.0%'))
    .registerValue('f', getNumberFormatter(',d'))
    .registerValue(',.', getNumberFormatter(',.4~f'))
    .registerValue('.1%f', getNumberFormatter('.1%'))
    .registerValue('1%', getNumberFormatter('.0%'))
    .registerValue('3%', getNumberFormatter('.0%'))
    .registerValue(',%', getNumberFormatter(',.0%'))
    .registerValue('.r', getNumberFormatter('.4~f'))
    .registerValue('$,.0', getNumberFormatter('$,d'))
    .registerValue('$,.1', getNumberFormatter('$,.1~f'))
    .registerValue(',0s', getNumberFormatter(',.4~f'))
    .registerValue('%%%', getNumberFormatter('.0%'))
    .registerValue(',0f', getNumberFormatter(',d'))
    .registerValue('+,%', getNumberFormatter('+,.0%'))
    .registerValue('$f', getNumberFormatter('$,d'))
    .registerValue('+,', getNumberFormatter(NumberFormats.INTEGER_SIGNED))
    .registerValue(',2f', getNumberFormatter(',.4~f'))
    .registerValue(',g', getNumberFormatter(',.4~f'))
    .registerValue('int', getNumberFormatter(NumberFormats.INTEGER))
    .registerValue('.0%f', getNumberFormatter('.1%'))
    .registerValue('$,0', getNumberFormatter('$,.4f'))
    .registerValue('$,0f', getNumberFormatter('$,.4f'))
    .registerValue('$,.f', getNumberFormatter('$,.4f'))
    .registerValue('DURATION', createDurationFormatter())
    .registerValue(
      'DURATION_SUB',
      createDurationFormatter({ formatSubMilliseconds: true }),
    )
    .registerValue(
      'DURATION_COL',
      createDurationFormatter({ colonNotation: true }),
    )
    .registerValue('MEMORY_DECIMAL', createMemoryFormatter({ binary: false }))
    .registerValue('MEMORY_BINARY', createMemoryFormatter({ binary: true }))

    // Custom D3 number formats with remapped keys:
    .registerValue(
      'custom_number_0f',
      createD3NumberFormatter({
        locale: {
          decimal: ',',
          thousands: '.',
          grouping: new Array(20).fill(3),
          currency: ['', ''],
        },
        formatString: '$,.0f',
      }),
    )
    .registerValue(
      'custom_number_1f',
      createD3NumberFormatter({
        locale: {
          decimal: ',',
          thousands: '.',
          grouping: new Array(20).fill(3),
          currency: ['', ''],
        },
        formatString: '$,.1f',
      }),
    )
    .registerValue(
      'custom_number_2f',
      createD3NumberFormatter({
        locale: {
          decimal: ',',
          thousands: '.',
          grouping: new Array(20).fill(3),
          currency: ['', ''],
        },
        formatString: '$,.2f',
      }),
    )
    .registerValue(
      'custom_number_3f',
      createD3NumberFormatter({
        locale: {
          decimal: ',',
          thousands: '.',
          grouping: new Array(20).fill(3),
          currency: ['', ''],
        },
        formatString: '$,.3f',
      }),
    )
    .registerValue(
      'custom_number_4f',
      createD3NumberFormatter({
        locale: {
          decimal: ',',
          thousands: '.',
          grouping: new Array(20).fill(3),
          currency: ['', ''],
        },
        formatString: '$,.4f',
      }),
    )
    .registerValue(
      'custom_percent_0',
      createD3NumberFormatter({
        locale: {
          decimal: ',',
          thousands: '.',
          grouping: new Array(20).fill(3),
          currency: ['', '%'],
        },
        formatString: '$,.0%',
      }),
    )
    .registerValue(
      'custom_percent_1',
      createD3NumberFormatter({
        locale: {
          decimal: ',',
          thousands: '.',
          grouping: new Array(20).fill(3),
          currency: ['', '%'],
        },
        formatString: '$,.1%',
      }),
    )
    .registerValue(
      'custom_percent_2',
      createD3NumberFormatter({
        locale: {
          decimal: ',',
          thousands: '.',
          grouping: new Array(20).fill(3),
          currency: ['', '%'],
        },
        formatString: '$,.2%',
      }),
    )
    .registerValue(
      'custom_percent_3',
      createD3NumberFormatter({
        locale: {
          decimal: ',',
          thousands: '.',
          grouping: new Array(20).fill(3),
          currency: ['', '%'],
        },
        formatString: '$,.3%',
      }),
    )
    .registerValue(
      'custom_percent_4',
      createD3NumberFormatter({
        locale: {
          decimal: ',',
          thousands: '.',
          grouping: new Array(20).fill(3),
          currency: ['', '%'],
        },
        formatString: '$,.4%',
      }),
    );

  const timeFormatterRegistry = getTimeFormatterRegistry();
  // If a d3TimeFormat was provided and the registry supports setting it, use it.
  if (d3TimeFormat && typeof timeFormatterRegistry.setD3Format === 'function') {
    timeFormatterRegistry.setD3Format(d3TimeFormat);
  }
  timeFormatterRegistry
    .registerValue(
      SMART_DATE_ID,
      createSmartDateFormatter(timeFormatterRegistry.d3Format),
    )
    .registerValue(
      SMART_DATE_VERBOSE_ID,
      createSmartDateVerboseFormatter(timeFormatterRegistry.d3Format),
    )
    .registerValue(
      SMART_DATE_DETAILED_ID,
      createSmartDateDetailedFormatter(timeFormatterRegistry.d3Format),
    )
    .setDefaultKey(SMART_DATE_ID);
}
