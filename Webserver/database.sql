-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 05. Apr 2021 um 12:43
-- Server-Version: 10.3.27-MariaDB-0+deb10u1
-- PHP-Version: 7.3.27-1~deb10u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `untisapp`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `authenticate`
--

CREATE TABLE `authenticate` (
  `ID` int(11) NOT NULL,
  `Server` varchar(32) NOT NULL,
  `School` varchar(32) NOT NULL,
  `User` varchar(32) NOT NULL,
  `Password` varchar(32) NOT NULL,
  `Client` varchar(12) NOT NULL,
  `sessionID` varchar(35) NOT NULL,
  `personID` varchar(32) NOT NULL,
  `personType` varchar(32) NOT NULL,
  `klasseID` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `authenticate`
--
ALTER TABLE `authenticate`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `authenticate`
--
ALTER TABLE `authenticate`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
